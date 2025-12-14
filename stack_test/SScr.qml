import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Page{

    Item{// block of signal listeners
        id: conector_block
        Rectangle{
            id: header_menu
            property int score:0;
            property int tval:0;
            Text{x:0;y:0;text: 'score: '+header_menu.score}
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
        // Add_box{ins: conector_block.val} //create example of element with inner listener
        Connections{
            enabled: true;
            target: container;
            function onDead(){
                console.log('you die');
                // snake_container.head_position = Qt.point(snake_container.head_position.x-rect.curent_way.x,snake_container.head_position.y-rect.curent_way.y);
                // var bod = (snake_body.count>0?snake_body.get(0).way:rect.curent_way);
                // snake_container.tail_position = Qt.point(snake_container.tail_position.x-bod.x,snake_container.tail_position.y-bod.y);
                // snake_body.set(0,{cellX: snake_body.get(1).cellX,cellY:snake_body.get(1).cellY});
                tims.running=false;
                second.running=false;
                repaint.running=false;
            }
        }
    }
    Item{
        id: container // main_container with some functions
        signal dead();
        function check_eq(cordx, cordy){
            // console.log('checked x: '+ cordx+' y: '+cordy);
            var min;
            var max;
            var item1 = snake_container.tail_position;
            item1 = {cellX:item1.x, cellY:item1.y};
            var item2 = (snake_body.count>0?snake_body.get(0):{cellX: snake_container.head_position.x, cellY: snake_container.head_position.y});
            var repeater = 0;
            do{
                if(cordx === item1.cellX){
                    min = Math.min(item1.cellY, item2.cellY);
                    max = Math.max(item1.cellY, item2.cellY);
                    if(cordy>=min&&cordy<=max)return true;
                }
                if(cordy === item1.cellY){
                    min = Math.min(item1.cellX, item2.cellX);
                    max = Math.max(item1.cellX, item2.cellX);
                    if(cordx>=min&&cordx<=max)return true;
                }
                item1 = snake_body.get(repeater);
                item2 = snake_body.get(repeater+1);
            }while(++repeater<(snake_body.count-1));
            if(snake_body.count>0){
                item1 = snake_body.get(snake_body.count-1);
                item2 = snake_container.head_position;
                item2 = {cellX:item2.x,cellY:item2.y}
                if(cordx === item1.cellX){
                    min = Math.min(item1.cellY, item2.cellY);
                    max = Math.max(item1.cellY, item2.cellY);
                    if(cordy>=min&&cordy<=max)return true;
                }
                if(cordy === item1.cellY){
                    min = Math.min(item1.cellX, item2.cellX);
                    max = Math.max(item1.cellX, item2.cellX);
                    if(cordx>=min&&cordx<=max)return true;
                }
            }
            for(var b=0; b<snake_body.count-1; b++){
                item1 = snake_body.get(b);
                item2 = snake_body.get(b+1);
                if(cordx === item1.cellX){
                    min = Math.min(item1.cellY, item2.cellY);
                    max = Math.max(item1.cellY, item2.cellY);
                    if(cordy>=min&&cordy<=max)return true;
                }
                if(cordy === item1.cellY){
                    min = Math.min(item1.cellX, item2.cellX);
                    max = Math.max(item1.cellX, item2.cellX);
                    if(cordx>=min&&cordx<=max)return true;
                }
            }
            for(var t=0; t<food_list.count;t++){
                var elem = food_list.get(t);
                if((elem.cellX===cordx) && (elem.cellY===cordy))return true;
            }
            return false;
        }
        function generate_random(max){ // random_positions generator, maximum == field_size
            let coordinatex = 0;
            let coordinatey = 0;
            do{
                coordinatex = Math.floor(Math.random()*(max+1)); //generate random x position of element
                coordinatey = Math.floor(Math.random()*(max+1)); //generate random y position of element
            // }while(checked_field.index(function(el){return el.cellX===coordinatex})===-1); //check if it`s cell empty
            }while(container.check_eq(coordinatex, coordinatey));

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
            property point tail_position: Qt.point(Math.floor((field_items.field_width)/2),Math.floor((field_items.field_height)/2)-2)//base tail position
            property double now: Date.now()-250;
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
                        var bod;
                        if(snake_body.count>0){
                            bod = snake_body.get(0).way;
                        }
                        else{
                            bod = rect.curent_way;
                        }
                        // snake_body.append({cellX: bod.cellX,cellY:bod.cellY, way: rect.curent_way});
                        snake_container.tail_position = Qt.point(snake_container.tail_position.x -bod.x, snake_container.tail_position.y-bod.y);
                        food_list.remove(i);
                        header_menu.score+=1;
                        food_container.food_generator();
                        // console.log(snake_body.count);
                        return;
                    }
                }
                // console.log('body check');
                if(snake_body.count>2){
                    // console.log('bodyc '+snake_body.count)
                    var smaller;
                    var bigger
                    var bitem_i = snake_container.tail_position;
                    bitem_i = {cellX:bitem_i.x,cellY:bitem_i.y};
                    var bitem_2i = snake_body.get(0);
                    // smaller = Math.min(bitem_i.cellX, bitem_2i.cellX);
                    // bigger = Math.max(bitem_i.cellX, bitem_2i.cellX);
                    var body_check = 0;
                    do{
                        // console.log('check');
                        if(head.cellY===bitem_i.cellY){
                            // console.log('check Y');
                            // check_area(smaller, bigger);
                            smaller = Math.min(bitem_i.cellX, bitem_2i.cellX);
                            bigger = Math.max(bitem_i.cellX, bitem_2i.cellX);
                            if(head.cellX>=smaller&&head.cellX<=bigger){
                                // console.log('die');
                                container.dead();
                                return;
                            }
                        }
                        if(head.cellX===bitem_i.cellX){
                            // console.log('check X');
                            smaller = Math.min(bitem_i.cellY, bitem_2i.cellY);
                            bigger = Math.max(bitem_i.cellY, bitem_2i.cellY);
                            if(head.cellY>=smaller&&head.cellY<=bigger){
                                console.log('die');
                                container.dead();
                                return;
                            }
                        }
                        bitem_i = snake_body.get(body_check);
                        bitem_2i = snake_body.get(body_check+1);
                    }while(++body_check<snake_body.count-1);


                    /*// for(var body_check = 0; body_check<snake_body.count-2; body_check++){
                    //     console.log('check');
                    //     bitem_i = snake_body.get(body_check);
                    //     bitem_2i = snake_body.get(body_check+1);
                    //     if(head.cellY===bitem_i.cellY){
                    //         console.log('check Y');
                    //         // check_area(smaller, bigger);
                    //         smaller = Math.min(bitem_i,cellX, bitem_2i.cellX);
                    //         bigger = Math.max(bitem_i,cellX, bitem_2i.cellX);
                    //         if(head.cellX>=smaller&&head.cellX<=bigger){
                    //             console.log('die');
                    //             container.dead();
                    //             return;
                    //         }
                    //     }
                    //     if(head.cellX===bitem_i.cellX){
                    //         console.log('check X');
                    //         smaller = Math.min(bitem_i,celly, bitem_2i.cellY);
                    //         bigger = Math.max(bitem_i,cellY, bitem_2i.cellY);
                    //         if(head.cellY>=smaller&&head.cellY<=bigger){
                    //             console.log('die');
                    //             container.dead();
                    //             return;
                    //         }
                    //     }
                    // }*/

                }


                /*// if(snake_body.count>3){ //if
                //     for(var iter=snake_body.count-1; iter>2; iter--){
                //         var body = snake_body.get(iter);
                //         if(body.cellX===head.cellX && body.cellY===head.cellY){
                //             console.log('boom');
                //             container.dead();
                //             return;
                //         }
                //     }
                // }
                // console.log('end body check');*/


            }
        }
        Item{//food elements logic
            id: food_container;
            ListModel{//list of coordinates
                id: food_list;
                ListElement{cellX:4; cellY:4}//first food element
            }
            function food_generator(){//generate food
                if(header_menu.score>90){
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
                froot.requestPaint();
                // field_items.cont.push({cellX:position.cellX,cellY:position.cellY,type:2});//push to main list of collisions
            }
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
        Canvas{
            id: fld;
            anchors.fill: parent;
            onPaint:{
                var ctx = getContext('2d');
                ctx.clearRect(0,0,width,height);
                ctx.save();
                ctx.strokeStyle = 'black'
                ctx.lineWidth = 2;
                for(var i=0; i<field_items.field_height; i++){
                    for(var j=0; j<field_items.field_width; j++){
                        ctx.fillStyle = ((i+j)%2==0)?'green':'lightgreen';
                        ctx.fillRect(j*30,i*30,30,30);
                        ctx.strokeRect(j*30,i*30,30,30);
                    }
                }
                ctx.restore();
            }
        }

        /*// GridLayout{
        //     id: grid;
        //     columns:  10;
        //     columnSpacing: 0;
        //     rowSpacing: 0;
        //     anchors.centerIn: parent;
        //     Repeater{
        //         model: 100;
        //         Rectangle{
        //             width:30;
        //             height: 30;
        //             property string pcol: ((model.index+Math.floor(model.index/grid.columns))%2==0)?("lightgreen"):("#a0f1c4");
        //             color:  pcol;
        //             border.color: "black";
        //             border.width: 1;
        //         }
        //     }
        // }*/
        Canvas{
            id: froot;
            anchors.fill: parent;
            onPaint:{
                var ctx = getContext('2d');
                ctx.clearRect(0,0,width,height);
                ctx.save();
                ctx.fillStyle= 'red';
                for(var i=0; i<food_list.count;i++){
                    var item = food_list.get(i);
                    ctx.beginPath();
                    ctx.arc(item.cellX*30+15, item.cellY*30+15, 10, 0, Math.PI*2);
                    ctx.fill();
                }
                ctx.restore();
            }
        }
        /*// Repeater{
        //     model: food_list;
        //     delegate: Rectangle{
        //         color: "red";
        //         width: 30;
        //         height: 30;
        //         radius: 20;
        //         x: model.cellX*30;
        //         y: model.cellY*30;
        //     }
        // }*/
        Rectangle{
            focus: true;
            id: rect;
            width: 30;
            height: 30;
            opacity: 0;
            x: snake_container.head_position.x*30;
            y: snake_container.head_position.y*30;
            z:1;
            // Behavior on x{
            //     NumberAnimation{
            //         duration: 250;
            //         easing.type: Easing.Linear;
            //     }
            // }
            // Behavior on y{
            //     NumberAnimation{
            //         duration: 250;
            //         easing.type: Easing.Linear;
            //     }
            // }
            visible: true;
            // radius: 20;
            color: "#1203F0";
            property point way: Qt.point(0,1);
            property point curent_way: Qt.point(0,1);
            property int base: 16777234;
            property int index: 3;

            // transformOrigin: Item.Center;
            // rotation: (((rect.curent_way.y===-1)?(1):(0))*180)-(rect.curent_way.x*90)
            // Rectangle{
            //     anchors.top: parent.top;
            //     width: parent.width;
            //     height: 15;
            //     color: parent.color;
            // }
            function set_way(){
                if(rect.curent_way===rect.way)return;
                if(rect.curent_way.x===(rect.way.y*(-1)) && rect.curent_way.y===rect.way.x){
                    rect.index = (rect.index===0)?(3):(rect.index-1);
                }else if((rect.curent_way.x===rect.way.y) && (rect.curent_way.y===(rect.way.x*(-1)))){
                    rect.index=(rect.index+1)%4;
                }
                snake_body.append({cellX:snake_container.head_position.x, cellY:snake_container.head_position.y, way:rect.curent_way})
                rect.curent_way = Qt.point(rect.way.x, rect.way.y);
            }
            function move(){
                rect.set_way();
                // var item;

                if(snake_body.count>0){
                    console.log(snake_body.count);
                    var last = snake_body.get(0);
                    snake_container.tail_position = Qt.point(snake_container.tail_position.x+last.way.x,snake_container.tail_position.y+last.way.y)
                    if(snake_container.tail_position.x === last.cellX && snake_container.tail_position.y === last.cellY){
                        snake_body.remove(0);
                    }
                }
                else{
                    snake_container.tail_position = Qt.point(snake_container.tail_position.x+rect.curent_way.x,snake_container.tail_position.y+rect.curent_way.y);
                }
                console.log(snake_container.tail_position.x + ' ' + snake_container.tail_position.y);
                // for(var i=snake_body.count-1; i>0;i--){
                //     snake_body.set(i,{cellX:snake_body.get(i-1).cellX,cellY:snake_body.get(i-1).cellY});
                //     // console.log(item);
                // }
                // snake_body.set(0, {cellX:snake_container.head_position.x,cellY:snake_container.head_position.y});
                // item = {cellX:item.cellX+rect.curent_way.x,cellY:item.cellY+rect.curent_way.y}
                snake_container.head_position = Qt.point(snake_container.head_position.x+rect.curent_way.x,snake_container.head_position.y+rect.curent_way.y)
                snake_container.now = Date.now();
                // body.requestPaint();
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
                    // console.log(rect.rotation);
                    // console.log(((rect.curent_way.y===-1)?(1):(0)*180)-(rect.curent_way.x*90));
                    // main_container.boxStumb();
                }else if(event.key === Qt.Key_2){
                    tims.running = true;
                    second.running=true;
                                    repaint.running=true;
                }else if(event.key === Qt.Key_3){
                    tims.running = false;
                    second.running=false;
                                    repaint.running=false;
                }else if(event.key === Qt.Key_4){
                    tims.running = false;
                    second.running=false;
                    stack.pop()
                }
            }
        }
        Canvas{
            id: body;
            property int size: 30;
            anchors.fill: parent;
            onPaint:{
                var ctx = getContext('2d');
                ctx.clearRect(0,0,width,height);
                ctx.save();
                ctx.fillStyle = 'blue';
                // console.log('paint');
                ctx.strokeStyle = 'blue';
                ctx.lineWidth = size*0.75;
                ctx.lineCap = 'round';
                ctx.lineJoin='round';

                var head = snake_container.head_position;
                var befp = Qt.point(head.x - rect.curent_way.x, head.y - rect.curent_way.y);
                // console.log(befp.x+' '+befp.y);
                var animt = Date.now() - snake_container.now;
                var prg = Math.min(1.0, animt/250);
                // console.log(prg);
                var newX = befp.x + (head.x-befp.x)*prg;
                var newY = befp.y + (head.y-befp.y)*prg;


                var tail = snake_container.tail_position;
                head = (snake_body.count>0?(snake_body.get(0).way):(rect.curent_way));
                befp = Qt.point(tail.x + head.x, tail.y + head.y);
                // head = Qt.point(newX, newY);
                // console.log(newX+' '+newY);

                ctx.beginPath();
                ctx.moveTo(newX*size+15,newY*size+15);
                newX = tail.x+ (befp.x-tail.x)*prg;
                newY = tail.y+ (befp.y-tail.y)*prg;
                for(var i=snake_body.count-1; i>-1; i--){
                    var point = snake_body.get(i);
                    ctx.lineTo(point.cellX*size+15,point.cellY*size+15)
                }
                ctx.lineTo(newX*size+15,newY*size+15);

                ctx.stroke();

                // for(var i=0; i<snake_body.count; i++){
                //     var item = snake_body.get(i);
                //     ctx.fillRect(item.cellX*size,item.cellY*size,size,size);
                // }
                ctx.restore();
            }
        }
        /*// Repeater{
        //     id:body_rect
        //     model: snake_body;
        //     delegate: Rectangle{
        //         id: rt;
        //         property bool last: (model.index === snake_body.count-1)||(model.index===0);
        //         color:"blue";
        //         width:30;
        //         height: 30;
        //         x: model.cellX*30;
        //         y:model.cellY*30;
        //     }
        // }*/
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
        Timer{
            id: repaint;
            interval: 16;
            repeat: true;
            running: false;
            onTriggered: {
                body.requestPaint();
            }
        }
        Component.onCompleted: {
            // snake_body.append({cellX:Math.floor((field_items.field_width)/2),cellY:Math.floor((field_items.field_height)/2)-1});
            // snake_body.append({cellX:Math.floor((field_items.field_width)/2),cellY:Math.floor((field_items.field_height)/2)-2});
            for(var t=0; t<5;t++){
                food_container.food_generator();
            }
            console.log(food_list.count);
            // console.log(field_items.cont.length);
            // rect.setBasePosition();
        }
    }
}
