package ;
import oglrenderer.OGLContainerCopy;
import oglrenderer.OGLContainer;
import openfl.display.Sprite;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class Main extends Sprite{
    public function new() {
        super();
        var a = new OGLContainer();
        var b = new OGLContainerCopy();
        addChild(a);
        addChild(new Pointer());
        addChild(b);
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
