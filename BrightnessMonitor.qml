import QtQuick
import Quickshell.Io

QtObject {
  id: root
  
  property int brightness: 0
  property int current: 0
  property int max: 1
  
  property Timer updateTimer: Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      currentFile.reload()
      maxFile.reload()
    }
  }
  
  property FileView currentFile: FileView {
    path: "/sys/class/backlight/nvidia_0/brightness"
    onLoaded: {
      root.current = parseInt(text().trim())
      root.updateBrightness()
    }
  }
  
  property FileView maxFile: FileView {
    path: "/sys/class/backlight/nvidia_0/max_brightness"
    onLoaded: {
      root.max = parseInt(text().trim())
      root.updateBrightness()
    }
  }
  
  function updateBrightness() {
    if (root.max > 0) {
      root.brightness = Math.round((root.current / root.max) * 100)
    }
  }
}
