import Quickshell
import Quickshell.Wayland
import QtQuick

// MangoWC Tag Indicator - shows current tag and layout
ShellRoot {
    Variants {
        model: Quickshell.screens
        
        // Tag number indicator (top)
        PanelWindow {
            id: tagWindow
            implicitWidth: 60
            implicitHeight: 60
            required property var modelData
            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            
            anchors {
                top: true
                right: true
            }
            
            margins {
                top: 70
                right:35
            }
            
            property var outputState: DwlService.getOutputState(modelData.name)
            
            property int activeTag: {
                if (!outputState || !outputState.tags) return 1
                
                for (let i = 0; i < outputState.tags.length; i++) {
                    if (outputState.tags[i].state === 1) {
                        return i + 1
                    }
                }
                return 1
            }
            
            Connections {
                target: DwlService
                function onStateChanged() {
                    tagWindow.outputState = DwlService.getOutputState(tagWindow.modelData.name)
                }
            }
            
            Text {
                anchors.centerIn: parent
                font.family: "Montserrat Black"
                font.weight: Font.Light
                font.pixelSize: 55
                color: "#c1c0c0"
                text: tagWindow.activeTag
            }
            
        }
    }
    
    Variants {
        model: Quickshell.screens
        
        // Layout symbol indicator (bottom)
        PanelWindow {
            id: layoutWindow
            implicitWidth: 70
            implicitHeight: 60
            required property var modelData
            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            
            anchors {
                bottom: true
                right: true
            }
            
            margins {
                right: 35
                bottom: 70
            }
            
            property var outputState: DwlService.getOutputState(modelData.name)
            property string layoutSymbol: outputState?.layout || ""
            
            Connections {
                target: DwlService
                function onStateChanged() {
                    layoutWindow.outputState = DwlService.getOutputState(layoutWindow.modelData.name)
                }
            }
            
            Text {
                anchors.centerIn: parent
                font.family: "Montserrat Black"
                font.weight: Font.Light
                font.pixelSize: 50
                color: "#b147c1"
                text: layoutWindow.layoutSymbol
                visible: layoutWindow.layoutSymbol !== ""
            }
        }
    }
}
