import QtQuick
import Quickshell.Services.Pipewire

QtObject {
  id: root
  
  property int volume: 0
  property bool muted: false
  property string icon: "󰕾"
  
  property PwObjectTracker tracker: PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ]
  }
  
  property Connections volumeConnection: Connections {
    target: Pipewire.defaultAudioSink?.audio
    
    function onVolumeChanged() {
      root.updateVolume()
    }
    
    function onMutedChanged() {
      root.updateVolume()
    }
  }
  
  Component.onCompleted: updateVolume()
  
  function updateVolume() {
    var sink = Pipewire.defaultAudioSink?.audio
    if (sink) {
      root.volume = Math.round(sink.volume * 100)
      root.muted = sink.muted
      root.updateIcon()
    }
  }
  
  function updateIcon() {
    if (root.muted || root.volume === 0) {
      root.icon = "󰖁"  // Muted
    } else if (root.volume < 33) {
      root.icon = "󰕿"  // Low
    } else if (root.volume < 66) {
      root.icon = "󰖀"  // Medium
    } else {
      root.icon = "󰕾"  // High
    }
  }
}
