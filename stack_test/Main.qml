import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: menu
    signal start(int ins);
    color: "#8ad0e1"
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    StackView{
        id:stack
        anchors.fill: parent
        initialItem: "SreenList.qml"
    }
}
