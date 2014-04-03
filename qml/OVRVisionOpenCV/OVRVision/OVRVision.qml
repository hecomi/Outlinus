import QtQuick 2.0
import OVRVision 1.0

OVRVision {
    property int frameRate: 60
    Timer {
        interval: 1000.0 / parent.frameRate
        running: true
        repeat: true
        onTriggered: parent.update()
    }
}
