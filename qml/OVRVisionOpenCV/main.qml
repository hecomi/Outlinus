import QtQuick 2.1
import 'OVRVision'

Rectangle {
    id: window
    width: 1280
    height: 480
    color: '#000'

    QtObject {
        id: setting

        property int defaultCameraWidth: 640
        property int defaultCameraHeight: 480
        property int cameraWidth: 640
        property int cameraHeight: 480

        property int threshold1: 50
        property int threshold2: 200
        property int medianBlurSize: 7

        property bool isCanny: false
        property bool isBitwiseNot: false
        property bool isMedianBlur: false
    }

    Rectangle {
        id: container
        width: 1280
        height: 480
        color: '#000'
        anchors.centerIn: parent

        Rectangle {
            id: leftCam
            width: setting.cameraWidth
            height: setting.cameraHeight
            anchors.left: parent.left
            anchors.top: parent.top
            OVRVision {
                camera: 0
                anchors.fill: parent
                cannyThreashold1: setting.threshold1
                cannyThreashold2: setting.threshold2
                medianBlurSize: setting.medianBlurSize
                isCanny: setting.isCanny
                isBitwiseNot: setting.isBitwiseNot
                isMedianBlur: setting.isMedianBlur
            }
        }

        Rectangle {
            id: rightCam
            width: setting.cameraWidth
            height: setting.cameraHeight
            anchors.right: parent.right
            anchors.top: parent.top
            OVRVision {
                camera: 1
                anchors.fill: parent
                cannyThreashold1: setting.threshold1
                cannyThreashold2: setting.threshold2
                medianBlurSize: setting.medianBlurSize
                isCanny: setting.isCanny
                isBitwiseNot: setting.isBitwiseNot
                isMedianBlur: setting.isMedianBlur
            }
        }
    }

    Text {
        id: usage
        font.pointSize: 18
        color: '#fff'
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: font.pointSize
        anchors.topMargin: font.pointSize
        text: getText()
        function getText() {
            var text = '';
            text += '<font color="#ff0">[UP/DOWN]</font> <b>SIZE</b> <font color="#ff0">[LEFT/RIGHT]</font> <b>DISTANCE</b> '
            text += '<font color="#ff0">[W/S]</font> <b>THRESHOLD1</b> <font color="#ff0">[A/D]</font> <b>THRESHOLD2</b> '
            text += '<font color="#ff0">[C]</font> <b>REAL/OUTLINE</b>'
            return text;
        }
    }

    Text {
        id: info
        font.pointSize: 18
        color: '#fff'
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: font.pointSize
        anchors.bottomMargin: font.pointSize
        text: getText()
        function getText() {
            var text = '';
            text += 'WIDTH: <font color="#0f0"><b>'  + setting.cameraWidth + '</b></font>';
            text += ' ';
            text += 'HEIGHT: <font color="#0f0"><b>' + setting.cameraHeight + '</b></font>';
            text += ' ';
            text += 'DISTANCE: <font color="#0ff"><b>' + ((container.width/2 - setting.cameraWidth)*2) + '</b></font>'
            text += ' ';
            text += 'THRESHOLD1: <font color="#0ff"><b>' + setting.threshold1 + '</b></font>';
            text += ' ';
            text += 'THRESHOLD2: <font color="#0ff"><b>' + setting.threshold2 + '</b></font>';
            text += ' ';
            text += 'BLUR SIZE: <font color="#0ff"><b>' + setting.medianBlurSize + '</b></font>';
            text += ' ';
            text += 'CANNY: <font color="#0ff"><b>' + (setting.isCanny ? "ON" : "OFF") + '</b></font>';
            text += ' ';
            text += 'NEGA: <font color="#0ff"><b>' + (setting.isBitwiseNot ? "ON" : "OFF") + '</b></font>';
            text += ' ';
            text += 'BLUR: <font color="#0ff"><b>' + (setting.isMedianBlur ? "ON" : "OFF") + '</b></font>';
            return text;
        }
    }

    focus: true
    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Left:
            container.width -= 10;
            break;
        case Qt.Key_Right:
            container.width += 10;
            break;
        case Qt.Key_Up:
            setting.cameraWidth += 10;
            setting.cameraHeight = setting.defaultCameraHeight *
                    setting.cameraWidth / setting.defaultCameraWidth;
            container.width += 20;
            break;
        case Qt.Key_Down:
            setting.cameraWidth -= 10;
            setting.cameraHeight = setting.defaultCameraHeight *
                    setting.cameraWidth / setting.defaultCameraWidth;
            container.width -= 20;
            break;
        case Qt.Key_C:
            setting.isCanny = !setting.isCanny;
            break;
        case Qt.Key_N:
            setting.isBitwiseNot = !setting.isBitwiseNot;
            break;
        case Qt.Key_M:
            setting.isMedianBlur = !setting.isMedianBlur;
            break;
        case Qt.Key_W:
            setting.threshold1 += 1;
            break;
        case Qt.Key_S:
            setting.threshold1 -= 1;
            break;
        case Qt.Key_D:
            setting.threshold2 += 1;
            break;
        case Qt.Key_A:
            setting.threshold2 -= 1;
            break;
        case Qt.Key_Q:
            setting.medianBlurSize -= 2;
            break;
        case Qt.Key_E:
            setting.medianBlurSize += 2;
            break;
        case Qt.Key_Escape:
            Qt.quit();
            break;
        }
    }
}
