{
  home.file.".config/karabiner/karabiner.json".text = ''
{
    "profiles": [
        {
            "complex_modifications": {
                "rules": [
                    {
                        "description": "Use the caps lock key state for other rules",
                        "manipulators": [
                            {
                                "conditions": [
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Set a variable to true/false depending on if caps lock is pressed/lifted.",
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": { "optional": ["any"] }
                                },
                                "to": [
                                    {
                                        "set_variable": {
                                            "name": "caps_lock pressed",
                                            "value": 1
                                        }
                                    }
                                ],
                                "to_after_key_up": [
                                    {
                                        "set_variable": {
                                            "name": "caps_lock pressed",
                                            "value": 0
                                        }
                                    }
                                ],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Disable the caps lock key entirely.",
                                "from": {
                                    "key_code": "caps_lock",
                                    "modifiers": { "optional": ["any"] }
                                },
                                "to_if_alone": [{ "key_code": "vk_none" }],
                                "type": "basic"
                            }
                        ]
                    },
                    {
                        "description": "Convert Caps Lock with [aou] to [äöü]",
                        "manipulators": [
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+a = ä",
                                "from": { "key_code": "a" },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    { "key_code": "a" },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+o = ö",
                                "from": { "key_code": "o" },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    { "key_code": "o" },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+u = ü",
                                "from": { "key_code": "u" },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    { "key_code": "u" },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            }
                        ]
                    },
                    {
                        "description": "Convert Caps Lock (in combination with Shift) with [aou] to [ÄÖÜ]",
                        "manipulators": [
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+shift+a = Ä",
                                "from": {
                                    "key_code": "a",
                                    "modifiers": { "mandatory": ["shift"] }
                                },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    {
                                        "key_code": "a",
                                        "modifiers": ["left_shift"]
                                    },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+shift+o = Ö",
                                "from": {
                                    "key_code": "o",
                                    "modifiers": { "mandatory": ["shift"] }
                                },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    {
                                        "key_code": "o",
                                        "modifiers": ["left_shift"]
                                    },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            },
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+shift+u = Ü",
                                "from": {
                                    "key_code": "u",
                                    "modifiers": { "mandatory": ["shift"] }
                                },
                                "to": [
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_option"]
                                    },
                                    {
                                        "key_code": "u",
                                        "modifiers": ["left_shift"]
                                    },
                                    { "key_code": "vk_none" }
                                ],
                                "type": "basic"
                            }
                        ]
                    },
                    {
                        "description": "Convert Caps Lock with [s] to [ß] (Eszett)",
                        "manipulators": [
                            {
                                "conditions": [
                                    {
                                        "name": "caps_lock pressed",
                                        "type": "variable_if",
                                        "value": 1
                                    },
                                    {
                                        "keyboard_types": ["ansi", "iso"],
                                        "type": "keyboard_type_if"
                                    },
                                    {
                                        "input_sources": [{ "language": "^en$" }],
                                        "type": "input_source_if"
                                    }
                                ],
                                "description": "Caps+s = ß",
                                "from": { "key_code": "s" },
                                "to": [
                                    {
                                        "key_code": "s",
                                        "modifiers": ["left_option"]
                                    }
                                ],
                                "type": "basic"
                            }
                        ]
                    },
                    {
                        "description": "Alt + Shift + S to capture a portion of the screen to clipboard",
                        "manipulators": [
                            {
                                "from": {
                                    "key_code": "s",
                                    "modifiers": { "mandatory": ["left_option", "left_shift"] }
                                },
                                "to": [
                                    {
                                        "key_code": "4",
                                        "modifiers": ["left_control", "left_command", "left_shift"]
                                    }
                                ],
                                "type": "basic"
                            }
                        ]
                    }
                ]
            },
            "devices": [
                {
                    "identifiers": { "is_keyboard": true },
                    "simple_modifications": [
                        {
                            "from": { "apple_vendor_top_case_key_code": "keyboard_fn" },
                            "to": [{ "key_code": "left_control" }]
                        },
                        {
                            "from": { "key_code": "left_control" },
                            "to": [{ "apple_vendor_top_case_key_code": "keyboard_fn" }]
                        }
                    ]
                },
                {
                    "identifiers": {
                        "is_keyboard": true,
                        "is_pointing_device": true,
                        "product_id": 591,
                        "vendor_id": 1452
                    },
                    "ignore": false
                }
            ],
            "name": "Default profile",
            "selected": true,
            "virtual_hid_keyboard": { "keyboard_type_v2": "ansi" }
        }
    ]
}
'';
}
