package ;
import openfl.events.Event;
import oglrenderer.OGLContainerCopy;
import oglrenderer.OGLContainer;
import openfl.display.Sprite;
class Main extends Sprite{
    var ups:Array<{update:Void->Void}> = [];
    var b:OGLContainerCopy;
    var a:OGLContainer;
    public function new() {
        super();
        a = new OGLContainer();
        b = new OGLContainerCopy();
        addChild(b);
        addChild(a);
//        addChild(new Pointer()); // uncommenting this line leads to crash

//        ups.push(cast b); // if i call invalidate() (within update() of containers) i loose VBO data of the firs object immediately
//        ups.push(cast a);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

   var t = 0;

    function onEnterFrame(e){
        for (u in ups)
            u.update();
//        t++;
//        if (t == 100)
//            addChild(a);
//        if (t==200)
//            removeChild(a);
    }
}

class Pointer extends Sprite {
    public function new () {
        super();
        graphics.beginFill(0xff0040);
        graphics.drawCircle(100,100,100);
        graphics.endFill();
    }
}
