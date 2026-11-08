import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import qs.DCommon.Widgets

PluginComponent {
    id: root

    readonly property string apiBase: "https://api.track.toggl.com/api/v9"
    property string tokenPath: (pluginData.tokenPath || "").trim()
    property int pollMinutes: Math.max(3, parseInt(pluginData.pollMinutes, 10) || 5)
    property bool showDescription: pluginData.showDescription ?? true

    property string token: ""
    readonly property string authHeader: token ? "Basic " + Qt.btoa(token + ":api_token") : ""
    property real now: Date.now()

    // Shared between bar instances on every screen so they spend one API
    // quota: Toggl allows 30 requests per hour on /me endpoints.
    PluginGlobalVar {
        id: gEntries
        varName: "entries"
        defaultValue: []
    }
    PluginGlobalVar {
        id: gWorkspaceId
        varName: "workspaceId"
        defaultValue: 0
    }
    PluginGlobalVar {
        id: gProjects
        varName: "projects"
        defaultValue: null
    }
    PluginGlobalVar {
        id: gError
        varName: "error"
        defaultValue: ""
    }
    PluginGlobalVar {
        id: gLastFetch
        varName: "lastFetch"
        defaultValue: 0
    }
    PluginGlobalVar {
        id: gBackoffUntil
        varName: "backoffUntil"
        defaultValue: 0
    }

    readonly property var entries: gEntries.value
    readonly property var current: entries.find(e => !e.stop) ?? null
    readonly property bool running: current !== null
    readonly property var recent: {
        const seen = {};
        const out = [];
        for (const e of entries) {
            if (!e.stop)
                continue;
            const key = (e.description || "") + "\u0000" + (e.project_id || 0);
            if (seen[key])
                continue;
            seen[key] = true;
            out.push(e);
            if (out.length >= 6)
                break;
        }
        return out;
    }
    readonly property real todaySeconds: {
        const midnight = new Date(now);
        midnight.setHours(0, 0, 0, 0);
        let total = 0;
        for (const e of entries) {
            const start = Date.parse(e.start);
            if (start < midnight.getTime())
                continue;
            total += e.stop ? e.duration : (now - start) / 1000;
        }
        return total;
    }

    FileView {
        id: tokenFile
        path: root.tokenPath
        onTextChanged: {
            root.token = tokenFile.text().trim();
            if (root.token)
                root.refresh(false);
            else
                root.setError(root.tokenPath ? "Token file is empty: " + root.tokenPath : "No API token file configured");
        }
        onLoadFailed: root.setError("Cannot read token file: " + root.tokenPath)
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.running
        onTriggered: root.now = Date.now()
    }

    Timer {
        interval: root.pollMinutes * 60000
        repeat: true
        running: root.token !== ""
        onTriggered: root.refresh(false)
    }

    function setError(message) {
        gError.set(message);
        if (message)
            console.warn("TogglTrack:", message);
    }

    function request(method, path, body, callback) {
        if (!token) {
            setError(tokenPath ? "Token file is empty or unreadable" : "No API token file configured");
            return;
        }
        if (Date.now() < gBackoffUntil.value)
            return;

        const xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status >= 200 && xhr.status < 300) {
                setError("");
                callback(xhr.responseText ? JSON.parse(xhr.responseText) : null);
                return;
            }
            if (xhr.status === 401 || xhr.status === 403) {
                setError("Toggl rejected the API token");
            } else if (xhr.status === 402 || xhr.status === 429) {
                const resetsIn = parseInt(xhr.getResponseHeader("X-Toggl-Quota-Resets-In"), 10) || 300;
                gBackoffUntil.set(Date.now() + resetsIn * 1000);
                setError("Toggl API quota reached, retrying in " + Math.ceil(resetsIn / 60) + " min");
            } else {
                setError("Toggl request failed (" + (xhr.status || "network error") + "): " + (xhr.responseText || "").slice(0, 120));
            }
        };
        xhr.open(method, apiBase + path);
        xhr.setRequestHeader("Authorization", authHeader);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.timeout = 15000;
        xhr.send(body ? JSON.stringify(body) : null);
    }

    function isoDate(date) {
        return date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, "0") + "-" + String(date.getDate()).padStart(2, "0");
    }

    // force skips the throttle that keeps several bar instances (and quick
    // popout reopens) from each spending a request.
    function refresh(force) {
        if (!token || (!force && Date.now() - gLastFetch.value < 60000))
            return;
        gLastFetch.set(Date.now());
        const from = new Date();
        from.setDate(from.getDate() - 7);
        const to = new Date();
        to.setDate(to.getDate() + 1);
        request("GET", "/me/time_entries?meta=true&start_date=" + isoDate(from) + "&end_date=" + isoDate(to), null, data => {
            gEntries.set(data || []);
            now = Date.now();
            if (!gWorkspaceId.value && data && data.length > 0)
                gWorkspaceId.set(data[0].workspace_id);
            if (gProjects.value === null)
                fetchProjects();
        });
    }

    // Projects rarely change, so they are fetched once per session (or on the
    // refresh IPC call). This is a workspace request, so it doesn't count
    // against the /me quota.
    function fetchProjects() {
        gProjects.set([]);
        withWorkspace(wid => request("GET", "/workspaces/" + wid + "/projects?active=true&per_page=200", null, data => {
            gProjects.set((data || []).map(p => ({ id: p.id, name: p.name, color: p.color })).sort((a, b) => a.name.localeCompare(b.name)));
        }));
    }

    readonly property var projects: gProjects.value || []

    function entryTitle(entry) {
        return entry?.description || entry?.project_name || "(no description)";
    }

    function entrySubtitle(entry) {
        return entry?.description ? (entry.project_name || "") : "";
    }

    function withWorkspace(callback) {
        if (gWorkspaceId.value) {
            callback(gWorkspaceId.value);
            return;
        }
        request("GET", "/me", null, me => {
            gWorkspaceId.set(me.default_workspace_id);
            callback(me.default_workspace_id);
        });
    }

    // Toggl stops the running entry itself when a new one starts.
    function start(description, projectId, tags, workspaceId) {
        const create = wid => request("POST", "/workspaces/" + wid + "/time_entries", {
            created_with: "dms-toggl-track",
            description: description || "",
            project_id: projectId || null,
            tags: tags || [],
            workspace_id: wid,
            start: new Date().toISOString().replace(/\.\d{3}Z$/, "Z"),
            duration: -1
        }, () => refresh(true));
        if (workspaceId)
            create(workspaceId);
        else
            withWorkspace(create);
    }

    function continueEntry(entry) {
        start(entry.description, entry.project_id, entry.tags, entry.workspace_id);
    }

    function stop() {
        if (!current)
            return;
        request("PATCH", "/workspaces/" + current.workspace_id + "/time_entries/" + current.id + "/stop", null, () => refresh(true));
    }

    function formatClock(iso) {
        if (!iso)
            return "";
        const d = new Date(iso);
        return String(d.getHours()).padStart(2, "0") + ":" + String(d.getMinutes()).padStart(2, "0");
    }

    // Moves the running entry's start to the given local "HH:MM" (or "HHMM").
    // A time later than now means yesterday, so a timer started before
    // midnight can still be corrected after it.
    function setStart(clock) {
        if (!current)
            return;
        const match = /^(\d{1,2}):?(\d{2})$/.exec((clock || "").trim());
        if (!match || +match[1] > 23 || +match[2] > 59) {
            setError("Start time must look like 09:30, got: " + clock);
            return;
        }
        const start = new Date();
        start.setHours(+match[1], +match[2], 0, 0);
        if (start.getTime() > Date.now())
            start.setDate(start.getDate() - 1);
        const id = current.id;
        request("PUT", "/workspaces/" + current.workspace_id + "/time_entries/" + id, {
            start: start.toISOString().replace(/\.\d{3}Z$/, "Z"),
            duration: -1
        }, data => {
            // Patch the cached entry instead of refetching, which would spend
            // one of the 30 hourly /me requests.
            gEntries.set(entries.map(e => e.id === id ? Object.assign({}, e, { start: data.start }) : e));
            now = Date.now();
        });
    }

    function toggle() {
        if (running)
            stop();
        else if (recent.length > 0)
            continueEntry(recent[0]);
        else
            start("");
    }

    function formatElapsed(seconds) {
        seconds = Math.max(0, Math.floor(seconds));
        const h = Math.floor(seconds / 3600);
        const m = Math.floor(seconds / 60) % 60;
        const s = seconds % 60;
        return h + ":" + String(m).padStart(2, "0") + ":" + String(s).padStart(2, "0");
    }

    function formatTotal(seconds) {
        const minutes = Math.floor(seconds / 60);
        return Math.floor(minutes / 60) + "h " + String(minutes % 60).padStart(2, "0") + "m";
    }

    readonly property real currentSeconds: current ? (now - Date.parse(current.start)) / 1000 : 0
    readonly property string barText: {
        if (!running)
            return "";
        const desc = current.description || current.project_name || "";
        const shortDesc = desc.length > 24 ? desc.slice(0, 23) + "…" : desc;
        return formatElapsed(currentSeconds) + (showDescription && shortDesc ? "  " + shortDesc : "");
    }

    pillRightClickAction: () => root.toggle()

    IpcHandler {
        target: "togglTrack"

        function toggle(): string {
            root.toggle();
            return root.running ? "stopping" : "starting";
        }

        function stop(): string {
            root.stop();
            return "stopping";
        }

        function start(description: string): string {
            root.start(description);
            return "starting";
        }

        function setStart(time: string): string {
            root.setStart(time);
            return "setting start to " + time;
        }

        function status(): string {
            if (gError.value)
                return "error: " + gError.value;
            if (!root.running)
                return "stopped";
            return root.formatElapsed(root.currentSeconds) + " " + (root.current.description || "");
        }

        function refresh(): string {
            root.refresh(true);
            root.fetchProjects();
            return "refreshing";
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS
            anchors.verticalCenter: parent.verticalCenter

            DIcon {
                name: gError.value ? "timer_off" : "timer"
                filled: root.running
                size: Theme.barIconSize(root.barThickness, undefined, root.barConfig?.maximizeWidgetIcons, root.barConfig?.iconScale)
                color: gError.value ? Theme.error : (root.running ? Theme.primary : Theme.widgetTextColor)
                anchors.verticalCenter: parent.verticalCenter
            }

            NumericText {
                visible: root.running
                text: root.barText
                isMonospace: false
                font.features: ({ "tnum": 1 })
                font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                font.weight: Font.Medium
                color: Theme.widgetTextColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.hairline(root.dpr)
            anchors.horizontalCenter: parent.horizontalCenter

            DIcon {
                name: gError.value ? "timer_off" : "timer"
                filled: root.running
                size: Theme.barIconSize(root.barThickness, undefined, root.barConfig?.maximizeWidgetIcons, root.barConfig?.iconScale)
                color: gError.value ? Theme.error : (root.running ? Theme.primary : Theme.widgetTextColor)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            NumericText {
                visible: root.running
                text: Math.floor(root.currentSeconds / 3600) + "\n" + String(Math.floor(root.currentSeconds / 60) % 60).padStart(2, "0")
                isMonospace: false
                font.features: ({ "tnum": 1 })
                font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                font.weight: Font.Medium
                color: Theme.widgetTextColor
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            headerText: "Toggl Track"
            detailsText: "Today " + root.formatTotal(root.todaySeconds)
            showCloseButton: true

            Component.onCompleted: root.refresh(false)

            Column {
                width: parent.width
                spacing: Theme.spacingM

                StyledText {
                    visible: gError.value !== ""
                    width: parent.width
                    text: gError.value
                    color: Theme.error
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                }

                StyledRect {
                    visible: root.running
                    width: parent.width
                    height: currentColumn.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh

                    Column {
                        id: currentColumn
                        anchors.left: parent.left
                        anchors.right: stopButton.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingXS

                        StyledText {
                            width: parent.width
                            text: root.entryTitle(root.current)
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            elide: Text.ElideRight
                        }

                        StyledText {
                            visible: text !== ""
                            width: parent.width
                            text: root.entrySubtitle(root.current)
                            font.pixelSize: Theme.fontSizeSmall
                            color: root.current?.project_color || Theme.surfaceVariantText
                            elide: Text.ElideRight
                        }

                        NumericText {
                            text: root.formatElapsed(root.currentSeconds)
                            isMonospace: false
                            font.features: ({ "tnum": 1 })
                            font.pixelSize: Theme.fontSizeXLarge
                            font.weight: Font.Bold
                            color: Theme.primary
                        }

                        Row {
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Started at"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            DTextField {
                                id: startField
                                // Follows the entry's start, but not while it is being edited.
                                readonly property string startText: root.formatClock(root.current?.start)
                                onStartTextChanged: if (!getActiveFocus()) text = startText
                                onFocusStateChanged: hasFocus => { if (!hasFocus) text = startText; }
                                Component.onCompleted: text = startText
                                width: 80
                                placeholderText: "HH:MM"
                                onAccepted: {
                                    root.setStart(text);
                                    setFocus(false);
                                }
                            }
                        }
                    }

                    DIconButton {
                        id: stopButton
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.spacingM
                        anchors.verticalCenter: parent.verticalCenter
                        size: "m"
                        variant: "filled"
                        iconName: "stop"
                        tooltipText: "Stop"
                        onClicked: root.stop()
                    }
                }

                DTextField {
                    id: descriptionField
                    width: parent.width
                    placeholderText: "What are you working on?"
                    onAccepted: startButton.clicked()
                }

                Row {
                    width: parent.width
                    spacing: Theme.spacingS

                    DDropdown {
                        id: projectDropdown
                        readonly property string noProject: "No project"
                        width: parent.width - startButton.width - parent.spacing
                        compactMode: true
                        dropdownWidth: width
                        triggerHeight: descriptionField.height
                        enableFuzzySearch: root.projects.length > 8
                        options: [noProject].concat(root.projects.map(p => p.name))
                        optionColorMap: {
                            const map = {};
                            for (const p of root.projects)
                                map[p.name] = p.color;
                            return map;
                        }
                        currentValue: noProject
                        onValueChanged: value => currentValue = value
                    }

                    DIconButton {
                        id: startButton
                        anchors.verticalCenter: parent.verticalCenter
                        buttonSize: descriptionField.height
                        width: descriptionField.height
                        variant: "filled"
                        iconName: "play_arrow"
                        tooltipText: "Start new entry"
                        onClicked: {
                            const project = root.projects.find(p => p.name === projectDropdown.currentValue);
                            root.start(descriptionField.text.trim(), project ? project.id : null);
                            descriptionField.text = "";
                        }
                    }
                }

                StyledText {
                    visible: root.recent.length > 0
                    text: "Recent"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceVariantText
                }

                Column {
                    width: parent.width
                    spacing: Theme.spacingXS

                    Repeater {
                        model: root.recent

                        StyledRect {
                            required property var modelData
                            width: parent.width
                            height: Math.max(recentText.implicitHeight, continueButton.height) + Theme.spacingS * 2
                            radius: Theme.cornerRadius
                            color: Theme.surfaceContainerHigh

                            Rectangle {
                                id: projectDot
                                width: 8
                                height: 8
                                radius: 4
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.spacingM
                                anchors.verticalCenter: parent.verticalCenter
                                color: modelData.project_color || Theme.surfaceVariantText
                            }

                            Column {
                                id: recentText
                                anchors.left: projectDot.right
                                anchors.right: continueButton.left
                                anchors.leftMargin: Theme.spacingS
                                anchors.rightMargin: Theme.spacingS
                                anchors.verticalCenter: parent.verticalCenter

                                StyledText {
                                    width: parent.width
                                    text: root.entryTitle(modelData)
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceText
                                    elide: Text.ElideRight
                                }

                                StyledText {
                                    visible: text !== ""
                                    width: parent.width
                                    text: root.entrySubtitle(modelData)
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    elide: Text.ElideRight
                                }
                            }

                            DIconButton {
                                id: continueButton
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.spacingS
                                anchors.verticalCenter: parent.verticalCenter
                                iconName: "play_arrow"
                                tooltipText: "Continue"
                                onClicked: root.continueEntry(modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
