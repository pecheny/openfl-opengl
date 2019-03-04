package ;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import openfl.events.Event;
import oglrenderer.OGLContainerCopy;
import oglrenderer.OGLContainer;
import openfl.display.Sprite;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class Main extends Sprite{
    var ups:Array<{update:Void->Void}> = [];
    var b:OGLContainerCopy;
    var a:OGLContainer;
    public function new() {
        trace("AGRH");
        super();
        a = new OGLContainer();
        b = new OGLContainerCopy();
//        addChild(new Pointer()); // uncommenting this line leads to crash
        addChild(a);
        addChild(b);

        ups.push(cast b); // if i call invalidate() (within update() of containers) i loose VBO data of the firs object immediately
        ups.push(cast a);
        addEventListener(RenderEvent.RENDER_OPENGL, render);
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

    var inited = false;

    public function init(gl:WebGLRenderContext) {
        a.init(gl);
        b.init(gl);
    }

    public function render(event:RenderEvent){
        if (!inited) {
            var renderer:OpenGLRenderer = cast event.renderer;
            var gl:WebGLRenderContext = renderer.gl;
            init(gl);
            inited = true;
            return;
        }

        a.render(event);
        b.render(event);
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
