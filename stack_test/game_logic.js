function min_max(cord, num1, num2){
    var min = Math.min(num1, num2);
    var max = Math.max(num1, num2);
    if(cord>=min&&cord<=max)return true;
}
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
            if(min_max(cordy, item1.cellY, item2.cellY))return true;
            // min = Math.min(item1.cellY, item2.cellY);
            // max = Math.max(item1.cellY, item2.cellY);
            // if(cordy>=min&&cordy<=max)return true;
        }
        if(cordy === item1.cellY){
            if(min_max(cordx, item1.cellX, item2.cellX))return true;
        }
        item1 = snake_body.get(repeater);
        item2 = snake_body.get(repeater+1);
    }while(++repeater<(snake_body.count));
    if(snake_body.count>0){
        item1 = snake_body.get(snake_body.count-1);
        item2 = snake_container.head_position;
        item2 = {cellX:item2.x,cellY:item2.y}
        if(cordx === item1.cellX){
            if(min_max(cordy, item1.cellY, item2.cellY))return true;
            // min = Math.min(item1.cellY, item2.cellY);
            // max = Math.max(item1.cellY, item2.cellY);
            // if(cordy>=min&&cordy<=max)return true;
        }
        if(cordy === item1.cellY){
            if(min_max(cordx, item1.cellX, item2.cellX))return true;
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
    }while(check_eq(coordinatex, coordinatey));

    return {cellX:coordinatex, cellY:coordinatey};//return object with coordinates
}

function check_collision(){
    var head = {cellX:snake_container.head_position.x, cellY:snake_container.head_position.y};
    if(snake_container.food_eaten){
        // snake_container.tail_position = Qt.point(snake_container.tail_position.x -bod.x, snake_container.tail_position.y-bod.y);
        food_list.remove(snake_container.food_index);
        header_menu.score+=1;
        food_container.food_generator();
        snake_container.food_eaten=false;
        snake_container.tail_way = Qt.point(0,0);
    }

    if(head.cellX > field_items.field_width-1||head.cellX<0|| head.cellY > field_items.field_height-1||head.cellY<0){
        console.log('boom');
        container.dead();
        return;
    }

    // console.log('food check');
    for(var i=0; i<food_list.count;i++){
        var item = food_list.get(i);
        if(snake_container.head_position.x===item.cellX &&snake_container.head_position.y===item.cellY){
            snake_container.food_eaten=true;
            snake_container.food_index=i;
            snake_container.tail_wait=true;
            // console.log(snake_body.count);
            return;
        }
    }
    // console.log('body check');
    if(snake_body.count>2){
        var smaller;
        var bigger
        var bitem_i = snake_container.tail_position;
        bitem_i = {cellX:bitem_i.x,cellY:bitem_i.y};
        var bitem_2i = snake_body.get(0);
        var body_check = 0;
        do{
            // console.log('check');
            if(head.cellY===bitem_i.cellY){
                // console.log('check Y');
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
    }
}
