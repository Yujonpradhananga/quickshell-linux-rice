import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData
            anchors {
                left: true
                bottom: true
            }
            margins {
                //right: 50    // X position from left
                top: 50      // Y position from top
            }
            width: 200
            height: 50
            color: "grey"
            Item {
                anchors.fill: parent
                SystemClock {
                    id: nigga
                }
                Text {
                    anchors.fill: parent
                    text: nigga.date.toLocaleString(Qt.locale("en_US"),"hh:mm")
                    color: "black"
                    font.family: "MonoLisa-Bold"
                    font.pointSize: 500
                    fontSizeMode: Text.Fit
                    layer.enabled: true
                }
            }
        }
    }
}
