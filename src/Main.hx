package ;
import openfl.events.Event;
import oglrenderer.OGLContainerCopy;
import oglrenderer.OGLContainer;
import openfl.display.Sprite;
class Main extends Sprite{
    var ups:Array<{update:Void->Void}> = [];

    public function new() {
        super();
        var a = new OGLContainer();
        var b = new OGLContainerCopy();
        addChild(b);
        addChild(a);

        ups.push(cast b);
        ups.push(cast a);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

//    function ac(c:Dynamic) {
//        addChild(c);
//        ups.push(c);
//    }

    function onEnterFrame(e){
        for (u in ups)
            u.update();
    }
}


