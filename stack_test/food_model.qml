import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
Component{
    id: slide_animation;
    Behavior on x{
        NumberAnimation{
            duration: 200;
            easing.type: Easing.OutInCirc;
        }
    }
    Behavior on y{
        NumberAnimation{
            duration: 200;
            easing.type: Easing.OutInCirc;
        }
    }
}
