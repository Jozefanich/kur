import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    color: menu.color
    RowLayout{
        anchors.centerIn: parent
        CheckBox{
            id:checks
            onCheckStateChanged: console.log(checks.checkState);
        }
        Button{
            text: "start game"
            onClicked: {
                stack.push("SScr.qml")
                menu.start(1);
            }
        }
        Button{
            text: "Exit"
            onClicked: Qt.quit()
        }
    }
}

