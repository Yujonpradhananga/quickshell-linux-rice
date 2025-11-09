import QtQuick
import Quickshell.Io

QtObject {
  id: root
  
  property int memUsed: 0
  property int memTotal: 1
  property int memPercentage: 0
  property string icon: "󰍛"
  
  property Timer updateTimer: Timer {
    interval: 5000  // 5 seconds is good for RAM
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      meminfoFile.reload()
    }
  }
  
  property FileView meminfoFile: FileView {
    path: "/proc/meminfo"
    onLoaded: {
      var data = text()
      
      // Parse MemTotal
      var totalMatch = data.match(/MemTotal:\s+(\d+)/)
      if (totalMatch) {
        root.memTotal = parseInt(totalMatch[1])
      }
      
      // Parse MemAvailable
      var availMatch = data.match(/MemAvailable:\s+(\d+)/)
      if (availMatch) {
        var memAvailable = parseInt(availMatch[1])
        root.memUsed = root.memTotal - memAvailable
      }
      
      root.updatePercentage()
    }
  }
  
  function updatePercentage() {
    if (root.memTotal > 0) {
      root.memPercentage = Math.round((root.memUsed / root.memTotal) * 100)
      root.updateIcon()
    }
  }
}
