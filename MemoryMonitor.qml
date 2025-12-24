import QtQuick
import Quickshell.Io

QtObject {
  id: root
  
  property int memUsed: 0
  property int memTotal: 1
  property int memPercentage: 0
  property string icon: "󰍛"
  
  property var updateTimer: Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: meminfoFile.reload()
  }
  
  property var meminfoFile: FileView {
    path: "/proc/meminfo"
    
    onLoaded: {
      const data = text()
      
      const totalMatch = data.match(/MemTotal:\s+(\d+)/)
      const availMatch = data.match(/MemAvailable:\s+(\d+)/)
      
      if (totalMatch && availMatch) {
        root.memTotal = parseInt(totalMatch[1])
        const memAvailable = parseInt(availMatch[1])
        root.memUsed = root.memTotal - memAvailable
        root.memPercentage = Math.round((root.memUsed / root.memTotal) * 100)
      }
    }
  }
}
