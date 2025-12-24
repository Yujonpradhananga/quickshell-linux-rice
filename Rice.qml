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
        top: 120
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
            topMargin: 200
          }
          Text{
            text: '"i hope peace"'
            color:"#5b239a"
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
            width: 145
            height: 40
            color:"#865546"
            radius: 9

            Text {
                anchors.fill: parent
                font.pixelSize: 60
                text: clock.date.toLocaleString(Qt.locale("en_US"), "hh:mm ap")
                color: "black"
                font.family: "Montserrat Light"
                font.weight: Font.Black
                font.pointSize: 1200
                fontSizeMode: Text.Fit
                layer.enabled: true
            }

          }

        }
      }
    }
  }
}
