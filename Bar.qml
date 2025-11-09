import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
ShellRoot {
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            
            anchors {
                right: true
                top: true
                bottom: true
            }
            
            margins {
                right: 5
                top: 5
                bottom: 6
            }
            
            implicitWidth: 35
            exclusionMode: ExclusionMode.Normal
            color: "black"
            
            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 5
                }
                spacing: 10
                
                // Workspaces - Fixed with hyprctl dispatch
                Column {
                    Layout.fillWidth: true
                    spacing: 5
                    
                    Repeater {
                        model: 10
                        
                        Rectangle {
                            width: 25
                            height: 25
                            color: "#313244"
                            radius: 5
                            
                            Text {
                                anchors.centerIn: parent
                                text: "󰫣"
                                color: "#cdd6f4"
                                font.pixelSize: 14
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    workspaceSwitch.running = false
                                    workspaceSwitch.command = ["hyprctl", "dispatch", "workspace", (index + 1).toString()]
                                    workspaceSwitch.running = true
                                }
                            }
                        }
                    }
                }
                
                // Spacer
                Item {
                    Layout.fillHeight: true
                }
                
                // Bottom section
                Column {
                    Layout.fillWidth: true
                    spacing: 15
                    Layout.alignment: Qt.AlignHCenter
                    
                    // Clock
                    Text {
                        id: clockText
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#cdd6f4"
                        font.pixelSize: 12
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        
                        property date currentTime: new Date()
                        
                        text: {
                            var hours = currentTime.getHours() % 12
                            if (hours === 0) hours = 12
                            var minutes = currentTime.getMinutes().toString().padStart(2, '0')
                            var ampm = currentTime.getHours() >= 12 ? "PM" : "AM"
                            return hours.toString().padStart(2, ' ') + "\n" + minutes + "\n" + ampm
                        }
                        
                        Timer {
                            interval: 60000
                            running: true
                            repeat: true
                            onTriggered: {
                                clockText.currentTime = new Date()
                            }
                        }
                        
                        Component.onCompleted: {
                            currentTime = new Date()
                        }
                    }
                    
                    // Battery
                    Text {
                        id: batteryText
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#cdd6f4"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        text: "󰂃\n--"
                    }
                    
                    // Memory - Fixed
                    Text {
                        id: memoryText
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#cdd6f4"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        text: "󰍛\n--"
                    }
                    
                    // Brightness - Fixed
                    Column {
                        width: parent.width
                        spacing: 5
                        
                        Rectangle {
                            width: 20
                            height: 100
                            color: "#313244"
                            radius: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                id: brightnessLevel
                                width: parent.width
                                color: "#89b4fa"
                                radius: 3
                                anchors.bottom: parent.bottom
                                property int brightness: 50
                                height: (brightness / 100) * parent.height
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onWheel: function(wheel) {
                                    if (wheel.angleDelta.y > 0) {
                                        brightnessUp.running = false
                                        brightnessUp.running = true
                                    } else {
                                        brightnessDown.running = false
                                        brightnessDown.running = true
                                    }
                                }
                            }
                        }
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "󰃟"
                            color: "#cdd6f4"
                            font.pixelSize: 16
                        }
                    }
                    
                    // Volume
                    Column {
                        width: parent.width
                        spacing: 5
                        
                        Rectangle {
                            width: 20
                            height: 100
                            color: "#313244"
                            radius: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                id: volumeLevel
                                width: parent.width
                                color: "#89b4fa"
                                radius: 3
                                anchors.bottom: parent.bottom
                                property int volume: 50
                                property bool muted: false
                                height: muted ? 0 : (volume / 100) * parent.height
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onWheel: function(wheel) {
                                    if (wheel.angleDelta.y > 0) {
                                        volumeUp.running = false
                                        volumeUp.running = true
                                    } else {
                                        volumeDown.running = false
                                        volumeDown.running = true
                                    }
                                }
                            }
                        }
                        
                        Text {
                            id: volumeIcon
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "#cdd6f4"
                            font.pixelSize: 16
                            
                            text: {
                                if (volumeLevel.muted) return "󰖁"
                                if (volumeLevel.volume < 33) return "󰕿"
                                if (volumeLevel.volume < 66) return "󰖀"
                                return "󰕾"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    volumeMuteProc.running = false
                                    volumeMuteProc.running = true
                                }
                            }
                        }
                    }
                }
            }
            
            // Background processes
            Process {
                id: workspaceSwitch
                command: ["hyprctl"]
                running: false
            }
            
            // Battery timer
            Timer {
                interval: 10000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    batteryCapacityProc.running = false
                    batteryCapacityProc.running = true
                    batteryStatusProc.running = false
                    batteryStatusProc.running = true
                }
            }
            
            Process {
                id: batteryCapacityProc
                command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
                running: true
                
                stdout: SplitParser {
                    onRead: function(data) {
                        var capacity = parseInt(data.trim())
                        if (isNaN(capacity)) return
                        
                        var icons = ["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]
                        var index = Math.floor(capacity / 10)
                        if (index > 9) index = 9
                        
                        if (batteryStatusProc.statusText.includes("Charging")) {
                            batteryText.text = "󰂄\n" + capacity
                        } else if (batteryStatusProc.statusText.includes("Full") || batteryStatusProc.statusText.includes("Not charging")) {
                            batteryText.text = "󱘖\n" + capacity
                        } else {
                            batteryText.text = icons[index] + "\n" + capacity
                        }
                    }
                }
            }
            
            Process {
                id: batteryStatusProc
                command: ["cat", "/sys/class/power_supply/BAT0/status"]
                running: true
                property string statusText: ""
                
                stdout: SplitParser {
                    onRead: function(data) {
                        batteryStatusProc.statusText = data.trim()
                    }
                }
            }
            
            // Memory timer - FIXED
            Timer {
                interval: 5000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    memoryProc.running = false
                    memoryProc.running = true
                }
            }
            
            Process {
                id: memoryProc
                command: ["sh", "-c", "free | grep Mem"]
                running: true
                
                stdout: SplitParser {
                    onRead: function(data) {
                        var parts = data.trim().split(/\s+/)
                        if (parts.length >= 3) {
                            var total = parseInt(parts[1])
                            var used = parseInt(parts[2])
                            if (!isNaN(total) && !isNaN(used) && total > 0) {
                                var percent = Math.round((used / total) * 100)
                                memoryText.text = "󰍛\n" + percent
                            }
                        }
                    }
                }
            }
            
            // Brightness timer - FIXED
            Timer {
                interval: 500
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    brightnessGetProc.running = false
                    brightnessGetProc.running = true
                }
            }
            
            Process {
                id: brightnessGetProc
                command: ["sh", "-c", "cat /sys/class/backlight/*/brightness"]
                running: true
                property string current: "0"
                
                stdout: SplitParser {
                    onRead: function(data) {
                        brightnessGetProc.current = data.trim()
                        var currentVal = parseInt(brightnessGetProc.current)
                        var maxVal = parseInt(brightnessMaxProc.max)
                        
                        if (!isNaN(currentVal) && !isNaN(maxVal) && maxVal > 0) {
                            var brightness = Math.round((currentVal / maxVal) * 100)
                            brightnessLevel.brightness = brightness
                        }
                    }
                }
            }
            
            Process {
                id: brightnessMaxProc
                command: ["sh", "-c", "cat /sys/class/backlight/*/max_brightness"]
                running: true
                property string max: "0"
                
                stdout: SplitParser {
                    onRead: function(data) {
                        brightnessMaxProc.max = data.trim()
                    }
                }
            }
            
            Process {
                id: brightnessUp
                command: ["brightnessctl", "set", "+5%"]
                running: false
            }
            
            Process {
                id: brightnessDown
                command: ["brightnessctl", "set", "5%-"]
                running: false
            }
            
            // Volume timer
            Timer {
                interval: 300
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    volumeGetProc.running = false
                    volumeGetProc.running = true
                    volumeGetMuteProc.running = false
                    volumeGetMuteProc.running = true
                }
            }
            
            Process {
                id: volumeGetProc
                command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
                running: true
                
                stdout: SplitParser {
                    onRead: function(data) {
                        var match = data.match(/(\d+)%/)
                        if (match) {
                            volumeLevel.volume = parseInt(match[1])
                        }
                    }
                }
            }
            
            Process {
                id: volumeGetMuteProc
                command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
                running: true
                
                stdout: SplitParser {
                    onRead: function(data) {
                        volumeLevel.muted = data.includes("yes")
                    }
                }
            }
            
            Process {
                id: volumeUp
                command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]
                running: false
            }
            
            Process {
                id: volumeDown
                command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]
                running: false
            }
            
            Process {
                id: volumeMuteProc
                command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
                running: false
            }
        }
    }
}
