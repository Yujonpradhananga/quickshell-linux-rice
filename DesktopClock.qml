import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            // THIS IS THE KEY: Set to background layer
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            
            anchors {
                left: true
                bottom: true
            }
            
            margins {
                left: 50     // X position from left
                bottom: 50   // Y position from bottom
            }
            
            width: 150
            height: 50
            color: "grey"
            
            Item {
                anchors.fill: parent
                
                SystemClock {
                    id: clock
                }
                
                Text {
                    anchors.fill: parent
                    text: clock.date.toLocaleString(Qt.locale("en_US"), "hh:mm")
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
