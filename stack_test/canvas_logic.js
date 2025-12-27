function drow(ctx, size) {
    ctx.fillStyle = 'blue';
    // console.log('paint');
    ctx.strokeStyle = 'blue';
    ctx.lineWidth = size*0.70;
    ctx.lineCap = 'round';
    ctx.lineJoin='round';

    var head = snake_container.head_position;
    var befp = Qt.point(head.x - snake_container.curent_way.x, head.y - snake_container.curent_way.y);
    var prg = Math.min(1.0, (Date.now() - snake_container.now)/250);
    var newX = befp.x + (snake_container.curent_way.x)*prg;
    var newY = befp.y + (snake_container.curent_way.y)*prg;


    var tail = snake_container.tail_position;
    var tail_way= snake_container.tail_way;
    ctx.beginPath();
    ctx.moveTo(newX*size+15,newY*size+15);
    newX = tail.x-tail_way.x*(1-prg);
    newY = tail.y-tail_way.y*(1-prg);
    for(var i=snake_body.count-1; i>-1; i--){
        var point = snake_body.get(i);
        ctx.lineTo(point.cellX*size+15,point.cellY*size+15)
    }
    ctx.lineTo(tail.x*size+15,tail.y*size+15)
    // if(!snake_container.food_eaten){
        // console.log('x: '+newX+' Y: '+newY)
        ctx.lineTo(newX*size+15,newY*size+15);
    // }
    ctx.stroke();
}
