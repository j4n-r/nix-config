import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.DCommon.Widgets

PluginSettings {
    id: root
    pluginId: "togglTrack"

    StyledText {
        width: parent.width
        text: "Toggl Track"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StringSetting {
        settingKey: "tokenPath"
        label: "API Token File"
        description: "Absolute path to a file containing your Toggl Track API token (Profile settings → API Token)."
        placeholder: "/run/secrets/toggl-api-token"
        defaultValue: ""
    }

    StringSetting {
        settingKey: "pollMinutes"
        label: "Refresh Interval (minutes)"
        description: "Toggl allows 30 requests per hour for your user, so keep this at 3 or more."
        placeholder: "5"
        defaultValue: "5"
    }

    ToggleSetting {
        settingKey: "showDescription"
        label: "Show Description in Bar"
        description: "Show the running entry's description next to the timer"
        defaultValue: true
    }
}
