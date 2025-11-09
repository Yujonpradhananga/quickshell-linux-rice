import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import "." as Local
ShellRoot{
  Variants{
    model: Quickshell.screens

    PanelWindow{
      id: panel
      required property var modelData
      screen: modelData
      color: "transparent"
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      Component.onCompleted: Local.BatteryMonitor.refCount++
      Component.onDestruction: Local.BatteryMonitor.refCount--
      anchors{
        right: true
        left: true
        top: true
        bottom: true
      }

      margins
      {
        right: 5
        left: 5
        top: 53
        bottom: 5
      }

      Rectangle{
        id: container
        color: "transparent"
        width: 600
        height: 600
        anchors{
          right:parent.right
          top:parent.top
          margins: 5
        }

        Row{
          id: maintime
          spacing: 8
          anchors{
            right: parent.right
            rightMargin: 40
            top: parent.top
            topMargin: 170
          }
          SystemClock {
            id: clock
            precision: SystemClock.Seconds
          }

          Text {
            id: clockdate
            color: "grey"
            text: Qt.formatDateTime(clock.date, "dd MMM yyyy")
            font.family:"Montserrat Light"
            font.weight:font.Light
            font.pixelSize:50
          }
        }
        Row{
          id: quote
          spacing: 8
          anchors{
            right: parent.right
            rightMargin: 10
            top: parent.top
            topMargin: 203
          }
          Text{
            text: '"I hope peace"'
            color:"lightgreen"
            font.family: "Glirock"
            font.pixelSize:90
          }

        }
        BrightnessMonitor { id: brightness }
        BatteryMonitor { id: battery }
        VolumeMonitor {id: volume}
        MemoryMonitor{id: memory}

        Row
        {
          id: stats
          spacing: 8
          anchors{
            right: parent.right
            rightMargin: 40
            top: parent.top
            topMargin: 310
          }
        Text {
            text: memory.icon + " " + memory.memPercentage + "%"
            font.family: "Montserrat Light"
            font.weight: Font.Light
            font.pixelSize: 40
            color: "grey"
          }
          Text {
            text: battery.icon + " " + battery.capacity + "%"
            font.family: "Montserrat Light"
            font.weight: Font.Light
            font.pixelSize: 40
            color: "grey"
          }
          Text {
              text: volume.icon + " " + volume.volume + "%"
              font.family: "Montserrat Light"
              font.weight: Font.Light
              font.pixelSize: 40
              color: "grey"
            }
          Text {
            text: "󰃠: " + brightness.brightness + "%"
            font.family: "Montserrat Light"
            font.weight: Font.Light
            font.pixelSize: 40
            color: "grey"
          }

        }
        Row{
          id: hour
          anchors{
            right: parent.right
            rightMargin: 40
            top: parent.top
            topMargin: 370
          }

          Rectangle{
            width: 160
            height: 50
            color: "lightblue"
            border.color: "lightblue"
            radius: 5

            Text {
                anchors.fill: parent
                text: clock.date.toLocaleString(Qt.locale("en_US"), "hh:mm ap")
                color: "black"
                font.family: "Montserrat Light"
                font.weight: Font.Black
                font.pointSize: 500
                fontSizeMode: Text.Fit
                layer.enabled: true
            }

          }

        }
      }
    }
  }
}
