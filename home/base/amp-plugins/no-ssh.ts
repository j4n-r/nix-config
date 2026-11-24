import type { PluginAPI } from '@ampcode/plugin'
import { readdir, readFile } from 'node:fs/promises'
import { dirname, join, resolve } from 'node:path'

export const description =
	'Refuses every shell command that would open an SSH connection: ssh, scp, sftp, mosh, tailscale ssh, remote rsync, ansible runs, and the Arrivo scripts that SSH into machines. Jan runs those himself. The local Windows test VMs from windows-vm/vm.py are the one exception.'

// Programs whose only job is an SSH connection. ssh and scp may still reach a local test VM, see sshAllowed.
const SSH_PROGRAMS = new Set([
	'ssh',
	'scp',
	'sftp',
	'slogin',
	'mosh',
	'autossh',
	'sshpass',
	'ssh-copy-id',
	'sshfs',
])

// Ansible commands that connect to hosts; ansible-lint, -doc, -galaxy, -vault, -inventory stay allowed.
const ANSIBLE_RUNNERS = new Set(['ansible', 'ansible-playbook', 'ansible-pull', 'ansible-console'])
const ANSIBLE_LOCAL_ONLY = /^--syntax-check$|^--list-(hosts|tasks|tags)$/

// Scripts in the Arrivo repo that SSH into customer servers, terminals or the inference box.
// windows-vm/vm.py is not here: it only talks to its own VMs on 127.0.0.1.
const ARRIVO_SSH_SCRIPT =
	/(^|\/)(push\.py|push_client\.py|run_vm_capture\.py|collect_day\.py|kpi_harvest\.py|replay_variant\.py|benchmark_report\.py|loop_common\.py|skills\/test\/harness\.py)$/
// Programs that run such a script when it is an argument; `cat push.py` or `rg x push.py` only read it.
const SCRIPT_RUNNERS = /^(python[\d.]*|uv|uvx|pipx|poetry|pdm|nix|bash|sh|zsh)$/

// Prefixes that run the next word as the actual command.
const WRAPPERS = new Set(['sudo', 'doas', 'env', 'command', 'exec', 'nohup', 'time', 'nice', 'timeout', 'xargs', 'watch', 'stdbuf'])
const SHELLS = new Set(['bash', 'sh', 'zsh', 'dash', 'ksh', 'fish', 'nu', 'su', 'pwsh'])
const INTERPRETERS = /^(python[\d.]*|node|bun|deno|perl|ruby|php)$/

// Local Windows test VMs: vm.py names them windows-vm-<profile> in temp/windows-vm/ssh_config, all on 127.0.0.1.
const TEST_VM_HOST = /^([^@\s]+@)?windows-vm-[a-z0-9-]+$/
const TEST_VM_SSH_CONFIG = 'temp/windows-vm/ssh_config'
const TEST_VM_INVENTORY = 'temp/windows-vm/inventory.ini'
const LOOPBACK = new Set(['127.0.0.1', 'localhost', '::1'])

// ssh and scp flags that take a value, and options that could send the connection somewhere else.
const SSH_VALUE_FLAGS = 'BbcDEeFIiJLlmOopQRSWw'
const SCP_VALUE_FLAGS = 'cDFiJloPSX'
const SSH_REDIRECTING_OPTION = /^(proxyjump|proxycommand|hostname|controlpath|controlmaster|localcommand|permitlocalcommand|include)$/i

// Ansible variables and keywords that change where a play connects.
const ANSIBLE_REDIRECT = /\b(add_host|ansible_(\w+_)?(host|args)|ansible_\w*proxy\w*)\b/
const DELEGATE_TO = /\bdelegate_to:\s*["']?([^"'\s#]+)/

const REASON =
	'Blocked by the no-ssh plugin: Amp may not open SSH connections (ssh, scp, sftp, rsync to a host, tailscale ssh, ansible runs, deploy scripts), except to the local Windows test VMs (ssh/scp to windows-vm-*, ansible with -i temp/windows-vm/inventory.ini). Do not try another route to the machine. Tell Jan the exact command so he can run it himself.'

interface Segment {
	words: string[]
	quoted: boolean[]
}

// Splits shell text into simple commands. Quoted text stays one word, so `rg 'ssh|x'` is a search, not
// an ssh call. Command substitutions inside double quotes come back in `nested`, since the shell runs them.
// Returns undefined for an unterminated quote, such as an apostrophe in a heredoc.
function parseShell(text: string): { segments: Segment[]; nested: string[] } | undefined {
	const segments: Segment[] = []
	const nested: string[] = []
	let words: string[] = []
	let quoted: boolean[] = []
	let word = ''
	let inWord = false
	let wasQuoted = false
	const endWord = () => {
		if (inWord) {
			words.push(word)
			quoted.push(wasQuoted)
		}
		word = ''
		inWord = false
		wasQuoted = false
	}
	const endSegment = () => {
		endWord()
		if (words.length > 0) segments.push({ words, quoted })
		words = []
		quoted = []
	}
	for (let i = 0; i < text.length; i++) {
		const c = text[i]!
		if (c === "'") {
			const end = text.indexOf("'", i + 1)
			if (end < 0) return undefined
			word += text.slice(i + 1, end)
			inWord = wasQuoted = true
			i = end
		} else if (c === '"') {
			let j = i + 1
			while (j < text.length && text[j] !== '"') {
				if (text[j] === '\\') {
					word += text[j + 1] ?? ''
					j += 2
				} else if (text[j] === '`') {
					const end = text.indexOf('`', j + 1)
					if (end < 0) return undefined
					nested.push(text.slice(j + 1, end))
					word += text.slice(j, end + 1)
					j = end + 1
				} else if (text.startsWith('$(', j)) {
					let depth = 1
					let k = j + 2
					for (; k < text.length && depth > 0; k++) {
						if (text[k] === '(') depth++
						else if (text[k] === ')') depth--
					}
					if (depth > 0) return undefined
					nested.push(text.slice(j + 2, k - 1))
					word += text.slice(j, k)
					j = k
				} else word += text[j++]
			}
			if (j >= text.length) return undefined
			inWord = wasQuoted = true
			i = j
		} else if (c === '\\') {
			word += text[++i] ?? ''
			inWord = true
		} else if (c === '\n' || ';&|()`'.includes(c)) {
			endSegment()
		} else if (c === '$' && text[i + 1] === '(') {
			endSegment()
			i++
		} else if (/\s/.test(c)) {
			endWord()
		} else {
			word += c
			inWord = true
		}
	}
	endSegment()
	return { segments, nested }
}

// Splits program text, such as `python -c` code, at every quote and bracket too, so that
// `subprocess.run(['ssh', host])` yields a segment that starts with ssh.
function parseCode(text: string): Segment[] {
	return text.split(/&&|\|\||[;&|()`\n"'[\],{}]|\$\(/).map((segment) => {
		const words = segment.trim().split(/\s+/).filter(Boolean)
		return { words, quoted: words.map(() => false) }
	})
}

const base = (word: string) => word.split('/').pop()!

// Drops wrappers, VAR=value assignments, and the flags and numbers (timeout 5) after a wrapper.
function stripPrefix({ words, quoted }: Segment): Segment & { assignments: string[] } {
	const assignments: string[] = []
	let start = 0
	let afterWrapper = false
	while (start < words.length) {
		const w = words[start]!
		const isWrapper = WRAPPERS.has(base(w))
		const isAssignment = /^[A-Za-z_][A-Za-z0-9_]*=/.test(w)
		if (!isWrapper && !isAssignment && !(afterWrapper && /^(-|\d+[smhd]?$)/.test(w))) break
		if (isAssignment) assignments.push(w)
		afterWrapper ||= isWrapper
		start++
	}
	return { words: words.slice(start), quoted: quoted.slice(start), assignments }
}

interface Context {
	cwd: string
	depth: number
}

async function blocked(text: string, mode: 'shell' | 'code', ctx: Context): Promise<boolean> {
	if (ctx.depth > 5) return true
	const inner = { ...ctx, depth: ctx.depth + 1 }
	const parsed = mode === 'shell' ? parseShell(text) : undefined
	const segments = parsed?.segments ?? parseCode(text)
	for (const nested of parsed?.nested ?? []) if (await blocked(nested, 'shell', inner)) return true
	for (const segment of segments) if (await segmentBlocked(segment, inner)) return true
	return false
}

async function segmentBlocked(segment: Segment, ctx: Context): Promise<boolean> {
	const { words, assignments } = stripPrefix(segment)
	if (words.length === 0) return false
	const program = base(words[0]!.replace(/^\^/, '')) // nushell runs externals as ^ssh
	const args = words.slice(1)

	// Text that another program runs as a command: a quoted program (`watch "ssh host"`), eval,
	// `bash -c`, `python -c`, `nix develop -c`, `nix-shell --run`.
	if (/\s/.test(words[0]!)) return blocked(words.join(' '), 'shell', ctx)
	if (program === 'eval') return blocked(args.join(' '), 'shell', ctx)
	for (let i = 1; i < words.length; i++) {
		const flag = words[i - 1]!
		const before = words.slice(0, i - 1).map(base)
		// An argv, not shell text: quoted again, so `nix develop -c bash -c 'a; b'` keeps its script whole.
		if (program === 'nix' && (flag === '-c' || flag === '--command'))
			return blocked(words.slice(i).map((w) => (/^[\w@%+=:,./-]+$/.test(w) ? w : `'${w.replace(/'/g, `'\\''`)}'`)).join(' '), 'shell', ctx)
		if (flag === '--run' && program === 'nix-shell') {
			if (await blocked(words[i]!, 'shell', ctx)) return true
		} else if (/^-[A-Za-z]*c$/.test(flag) && before.some((w) => SHELLS.has(w))) {
			if (await blocked(words[i]!, 'shell', ctx)) return true
		} else if (/^-[A-Za-z]*[ce]$/.test(flag) && before.some((w) => INTERPRETERS.test(w))) {
			if (await blocked(words[i]!, 'code', ctx)) return true
		}
	}

	if (words.some((w, i) => ARRIVO_SSH_SCRIPT.test(w) && (i === 0 || SCRIPT_RUNNERS.test(program)))) return true
	if (program === 'ssh' || program === 'scp') return !sshAllowed(program, args)
	if (SSH_PROGRAMS.has(program)) return true
	if (program === 'tailscale' && args.includes('ssh')) return true
	if (program === 'rsync' && args.some((a) => a === '-e' || a.startsWith('--rsh') || a.startsWith('rsync://') || /^[^/\s-][^/\s]*:/.test(a)))
		return true
	if (ANSIBLE_RUNNERS.has(program)) {
		if (args.some((a) => ANSIBLE_LOCAL_ONLY.test(a))) return false
		if (assignments.some((a) => a.startsWith('ANSIBLE_'))) return true
		return !(await ansibleAllowed(args, ctx.cwd))
	}
	return false
}

// ssh and scp may connect only to windows-vm-* hosts, with no option that points the connection elsewhere.
// The ssh_config vm.py writes includes ~/.ssh/config, so its ssh wrapper alone does not limit the target.
function sshAllowed(program: 'ssh' | 'scp', args: string[]): boolean {
	const valueFlags = program === 'ssh' ? SSH_VALUE_FLAGS : SCP_VALUE_FLAGS
	const positional: string[] = []
	for (let i = 0; i < args.length; i++) {
		const a = args[i]!
		if (program === 'ssh' && positional.length > 0) break // the remote command follows the host
		if (a === '--') {
			positional.push(...args.slice(i + 1))
			break
		}
		if (!a.startsWith('-') || a === '-') {
			positional.push(a)
			continue
		}
		for (let k = 1; k < a.length; k++) {
			const flag = a[k]!
			if (!valueFlags.includes(flag)) continue
			const value = k + 1 < a.length ? a.slice(k + 1) : args[++i]
			if (value === undefined) return false
			if ('JSW'.includes(flag)) return false
			if (flag === 'o' && SSH_REDIRECTING_OPTION.test(value.split(/[=\s]/)[0]!)) return false
			if (flag === 'F' && !value.endsWith(TEST_VM_SSH_CONFIG)) return false
			break
		}
	}
	if (program === 'ssh') return positional.length > 0 && TEST_VM_HOST.test(positional[0]!)
	const remotes = positional.filter((p) => p.startsWith('scp://') || /^[^/.][^/]*:/.test(p))
	return remotes.length > 0 && remotes.every((r) => !r.startsWith('scp://') && TEST_VM_HOST.test(r.slice(0, r.indexOf(':'))))
}

// Ansible may run only against the inventory vm.py writes, and only when every host in it is on loopback
// and nothing in the command, the vars directories or the playbook and its roles redirects a connection.
// Plays imported from other directories and roles from installed collections are not checked.
async function ansibleAllowed(args: string[], cwd: string): Promise<boolean> {
	const inventories: string[] = []
	const playbooks: string[] = []
	for (let i = 0; i < args.length; i++) {
		const a = args[i]!
		const eq = a.startsWith('--') ? a.indexOf('=') : -1
		const flag = eq > 0 ? a.slice(0, eq) : a
		const inline = eq > 0 ? a.slice(eq + 1) : undefined
		if (['-i', '--inventory', '--inventory-file'].includes(flag)) inventories.push(inline ?? args[++i] ?? '')
		else if (['-e', '--extra-vars'].includes(flag)) {
			const value = inline ?? args[++i] ?? ''
			if (value.startsWith('@') || ANSIBLE_REDIRECT.test(value)) return false
		} else if (/^--(ssh|scp|sftp)-\w+-args$/.test(flag)) return false
		else if (/^-[ie]./.test(a)) return false
		else if (/\.ya?ml$/.test(a)) playbooks.push(a)
	}
	if (inventories.length === 0) return false
	for (const inventory of inventories) {
		const path = resolve(cwd, inventory)
		if (!path.endsWith(TEST_VM_INVENTORY)) return false
		const text = await readFile(path, 'utf8').catch(() => undefined)
		if (text === undefined || !inventoryOnLoopback(text) || (await varsRedirect(dirname(path)))) return false
	}
	for (const playbook of playbooks) {
		const path = resolve(cwd, playbook)
		const text = await readFile(path, 'utf8').catch(() => '')
		if (redirects(text) || (await varsRedirect(dirname(path))) || (await treeRedirects(join(dirname(path), 'roles')))) return false
	}
	return true
}

function inventoryOnLoopback(text: string): boolean {
	let section = ''
	let hosts = 0
	for (const raw of text.split('\n')) {
		const line = raw.replace(/\s[#;].*$/, '').trim()
		if (!line || line.startsWith('#') || line.startsWith(';')) continue
		const header = line.match(/^\[([^\]]+)\]$/)
		if (header) section = header[1]!
		else if (section.endsWith(':children')) continue
		else if (section.endsWith(':vars')) {
			if (ANSIBLE_REDIRECT.test(line)) return false
		} else {
			const host = line.match(/\bansible_host=["']?([^"'\s]+)/)
			if (!host || !LOOPBACK.has(host[1]!)) return false
			if (ANSIBLE_REDIRECT.test(line.replace(/\bansible_host=\S+/, ''))) return false
			hosts++
		}
	}
	return hosts > 0
}

function redirects(text: string): boolean {
	return text.split('\n').some((line) => {
		if (line.trimStart().startsWith('#')) return false
		const delegate = line.match(DELEGATE_TO)
		return ANSIBLE_REDIRECT.test(line) || (delegate !== null && !LOOPBACK.has(delegate[1]!))
	})
}

async function varsRedirect(dir: string): Promise<boolean> {
	return (await treeRedirects(join(dir, 'group_vars'))) || (await treeRedirects(join(dir, 'host_vars')))
}

async function treeRedirects(dir: string): Promise<boolean> {
	const files = await readdir(dir, { recursive: true }).catch(() => [] as string[])
	for (const file of files) {
		const text = await readFile(join(dir, file), 'utf8').catch(() => '')
		if (redirects(text)) return true
	}
	return false
}

export default function (amp: PluginAPI) {
	amp.on('tool.call', async (event) => {
		const command = event.input.command ?? event.input.cmd
		const cwd = event.input.workdir ?? event.input.cwd ?? process.cwd()
		if (typeof command === 'string' && (await blocked(command, 'shell', { cwd: String(cwd), depth: 0 }))) {
			return { action: 'reject-and-continue', message: REASON }
		}
		return { action: 'allow' }
	})
}
