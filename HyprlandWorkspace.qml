import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland

ShellRoot {
  Variants {
    model: Quickshell.screens
    
    PanelWindow {
      id: root
      width: 60
      height: 60
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
        right: 55
        bottom: 70
      }
      
      Rectangle {
        anchors.fill: parent
        color:"grey"
        border.color: "grey"
        radius: 8
        
        Text {
          anchors.centerIn: parent
          font.family: "Montserrat Black"
          font.weight: Font.Light
          font.pixelSize: 50
          color: "black"
          // Direct binding - no intermediate property needed
          text: Hyprland.focusedWorkspace?.id ?? "?"
        }
      }
    }
  }
}
