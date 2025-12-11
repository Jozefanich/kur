import QtQuick

Item {
    id: enebled_box_mode
    property int ins: 1;
    Connections{
        enabled: enebled_box_mode.ins==1;
        target: main_container;
        function onBoxStumb(){
            console.log('tr');
        }
    }
}
