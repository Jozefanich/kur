import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Page{

    Item{// block of signal listeners
        id: conector_block
        Rectangle{
            id: header_menu
            property int val:0;
            property int tval:0;
            Text{x:0;y:0;text: 'score: '+header_menu.val}
            Text{x:0;y:20;text: 'time: '+header_menu.tval}
        }
        property int val: 1;
        Connections{ // connect to signal `start` from main_menu page
            enabled: true; // connection enabled
            target: menu; // target element wich send signal
            function onStart(ins){ //function
                conector_block.val = ins; // for activate game_mode 1=true, 0=false
            }
        }
        Add_box{ins: conector_block.val} //create example of element with inner listener
        Connections{
            enabled: true;
            target: container;
            function onDead(){
                console.log('you die');
                snake_container.head_position = Qt.point(snake_container.head_position.x-rect.curent_way.x,snake_container.head_position.y-rect.curent_way.y);
                snake_body.set(0,{cellX: snake_body.get(1).cellX,cellY:snake_body.get(1).cellY});
                tims.running=false;
                second.running=false;
            }
        }
    }
    Item{
        id: container // main_container with some functions
        signal dead();
        function check_eq(elem, cordx, cordy){
            // console.log('checked x: '+ cordx+' y: '+cordy);
            for(var t=0; t<elem.length;t++){
                if((elem[t].cellX===cordx) && (elem[t].cellY===cordy))return true;
            }
            return false;
        }
        function generate_random(max){ // random_positions generator, maximum == field_size
            let coordinatex = 0;
            let coordinatey = 0;
            var checked_field = [];
            for(var snake_iterator=0; snake_iterator<snake_body.count; snake_iterator++){
                checked_field.push(snake_body.get(snake_iterator));
            }
            for(var food_iterator=0; food_iterator<food_list.count; food_iterator++){
                checked_field.push(food_list.get(food_iterator));
            }
            do{
                coordinatex = Math.floor(Math.random()*(max+1)); //generate random x position of element
                coordinatey = Math.floor(Math.random()*(max+1)); //generate random y position of element
            // }while(checked_field.index(function(el){return el.cellX===coordinatex})===-1); //check if it`s cell empty
            }while(container.check_eq(checked_field, coordinatex, coordinatey));

            return {cellX:coordinatex, cellY:coordinatey};//return object with coordinates
        }
        Item{//only for random generate
            id: field_items;
            property int field_width: 10;
            property int field_height: 10;
            property var cont: [{cellX:4,cellY:4}]; //array of item objects
        }
        Item{//snake positions and functions container
            id: snake_container;
            property point head_position: Qt.point(Math.floor((field_items.field_width)/2),Math.floor((field_items.field_height)/2))//base head position
            // property int snake_lenght: 1; // snake len,
            // property var snake_body_positions: new Array;//array of body positions, in checking collisions it may join into cont array
            ListModel{
                id: snake_body;
            }

            function check_collision(){
                var head = {cellX:snake_container.head_position.x, cellY:snake_container.head_position.y};
                if(head.cellX > field_items.field_width-1||head.cellX<0|| head.cellY > field_items.field_height-1||head.cellY<0){
                    console.log('boom');
                    container.dead();
                    return;
                }
                // console.log('food check');
                for(var i=0; i<food_list.count;i++){
                    var item = food_list.get(i);
                    if(snake_container.head_position.x===item.cellX &&snake_container.head_position.y===item.cellY){
                        // console.log('got it');
                        var bod = snake_body.get(snake_body.count-1);
                        snake_body.append({cellX: bod.cellX,cellY:bod.cellY});
                        food_list.remove(i);
                        header_menu.val+=1;
                        food_container.food_generator();
                        // console.log(snake_body.count);
                        return;
                    }
                }
                // console.log('body check');
                if(snake_body.count>3){ //if
                    for(var iter=snake_body.count-1; iter>2; iter--){
                        var body = snake_body.get(iter);
                        if(body.cellX===head.cellX && body.cellY===head.cellY){
                            console.log('boom');
                            container.dead();
                            return;
                        }
                    }
                }
                // console.log('end body check');


            }
        }
        Item{//food elements logic
            id: food_container;
            ListModel{//list of coordinates
                id: food_list;
                ListElement{cellX:4; cellY:4}//first food element
            }
            // property var food_logic_position: new Array;
            // property int max_count: 1;//maximum food count
            function food_generator(){//generate food
                if((snake_body.count+food_list.count)>99){
                    if(food_list.count===0){
                        console.log('you win');
                        tims.running=false;
                        second.running=false;
                    }
                    return;
                }
                var position = container.generate_random(field_items.field_width-1); // get random empty position
                // console.log(position.cellX);
                food_list.append(position); //append coordinates to food_list
                // field_items.cont.push({cellX:position.cellX,cellY:position.cellY,type:2});//push to main list of collisions
            }
        }
        Item{//delete in close future, appent mode, connection qml file
            id: boxs_conteiner;
            property var box_logic_positions: new Array;
            property bool added: false;
        }
    }



    background: menu.color; // set bg color, but this method is illegal
    focus: true;    //set focus to this page
    Item{
        id: main_container;
        signal boxStumb();
        anchors.centerIn: parent;
        Rectangle{
            id:field;
            anchors.centerIn: parent;
            width: 10*30;
            height: 10*30;
        GridLayout{
            id: grid;
            columns:  10;
            columnSpacing: 0;
            rowSpacing: 0;
            anchors.centerIn: parent;
            Repeater{
                model: 100;
                Rectangle{
                    width:30;
                    height: 30;
                    property string pcol: ((model.index+Math.floor(model.index/grid.columns))%2==0)?("lightgreen"):("#a0f1c4");
                    color:  pcol;
                    border.color: "black";
                    border.width: 1;
                }
            }
        }
        Repeater{
            model: food_list;
            delegate: Rectangle{
                color: "red";
                width: 30;
                height: 30;
                radius: 20;
                x: model.cellX*30;
                y: model.cellY*30;
            }
        }
        Rectangle{
            focus: true;
            id: rect;
            width: 30;
            height: 30;
            x: snake_container.head_position.x*30;
            y: snake_container.head_position.y*30;
            z:1;
            Behavior on x{
                NumberAnimation{
                    duration: 250;
                    easing.type: Easing.Linear;
                }
            }
            Behavior on y{
                NumberAnimation{
                    duration: 250;
                    easing.type: Easing.Linear;
                }
            }
            visible: true;
            radius: 20;
            color: "#1203F0";
            property point way: Qt.point(0,1);
            property point curent_way: Qt.point(0,1);
            property int base: 16777234;
            property int index: 3;

            transformOrigin: Item.Center;
            rotation: (((rect.curent_way.y===-1)?(1):(0))*180)-(rect.curent_way.x*90)
            Rectangle{
                anchors.top: parent.top;
                width: parent.width;
                height: 15;
                color: parent.color;
            }
            function set_way(){
                if(rect.curent_way===rect.way)return;
                if(rect.curent_way.x===(rect.way.y*(-1)) && rect.curent_way.y===rect.way.x){
                    rect.index = (rect.index===0)?(3):(rect.index-1);
                }else if((rect.curent_way.x===rect.way.y) && (rect.curent_way.y===(rect.way.x*(-1)))){
                    rect.index=(rect.index+1)%4;
                }
                rect.curent_way = Qt.point(rect.way.x, rect.way.y);
            }
            function move(){
                rect.set_way();
                // var item;
                for(var i=snake_body.count-1; i>0;i--){
                    snake_body.set(i,{cellX:snake_body.get(i-1).cellX,cellY:snake_body.get(i-1).cellY});
                    // console.log(item);
                }
                snake_body.set(0, {cellX:snake_container.head_position.x,cellY:snake_container.head_position.y});
                // item = {cellX:item.cellX+rect.curent_way.x,cellY:item.cellY+rect.curent_way.y}
                snake_container.head_position = Qt.point(snake_container.head_position.x+rect.curent_way.x,snake_container.head_position.y+rect.curent_way.y)
                snake_container.check_collision();
            }
            Keys.onPressed: (event)=>{
                if(event.key === rect.base+((rect.index+1)%4)){
                    rect.way = Qt.point(rect.curent_way.y*(-1), rect.curent_way.x);
                }else if(event.key === rect.base+((rect.index===0)?(3):(rect.index-1))){
                    rect.way = Qt.point(rect.curent_way.y, rect.curent_way.x*(-1));
                }else if(event.key === Qt.Key_1){
                    rect.move();
                    // console.log(rect.x+' '+rect.y);
                    console.log(rect.rotation);
                    console.log(((rect.curent_way.y===-1)?(1):(0)*180)-(rect.curent_way.x*90));
                    // main_container.boxStumb();
                }else if(event.key === Qt.Key_2){
                    tims.running = true;
                    second.running=true;
                }else if(event.key === Qt.Key_3){
                    tims.running = false;
                    second.running=false;
                }else if(event.key === Qt.Key_4){
                    tims.running = false;
                    second.running=false;
                    stack.pop()
                }
            }
        }

        Repeater{
            id:body_rect
            model: snake_body;
            delegate: Rectangle{
                id: rt;
                property bool last: (model.index === snake_body.count-1)||(model.index===0);
                color:"blue";
                width:30;
                height: 30;
                x: model.cellX*30;
                y:model.cellY*30;
                // Behavior on x{
                //     enabled: last;
                //     NumberAnimation{
                //         duration: 150;
                //         easing.type: Easing.Linear;
                //     }
                // }
                // Behavior on y{
                //     enabled: last;
                //     NumberAnimation{
                //         duration: 150;
                //         easing.type: Easing.Linear;
                //     }
                // }
            }
        }
        }

        Timer{
            id: tims;
            interval: 250;
            repeat: true;
            running: false;
            onTriggered:{
                rect.move();
            }
        }
        Timer{
            id: second;
            interval: 1000;
            repeat: true;
            running: false;
            onTriggered:{
                header_menu.tval+=1;
            }
        }
        Component.onCompleted: {
            snake_body.append({cellX:Math.floor((field_items.field_width)/2),cellY:Math.floor((field_items.field_height)/2)-1});
            snake_body.append({cellX:Math.floor((field_items.field_width)/2),cellY:Math.floor((field_items.field_height)/2)-2});
            for(var t=0; t<5;t++){
                food_container.food_generator();
            }
            console.log(food_list.count);
            // console.log(field_items.cont.length);
            // rect.setBasePosition();
        }
    }
}
