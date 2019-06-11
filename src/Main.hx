package ;
import mesh.AssetMeshProvider;
import shader.DummyShader;
import openfl.display.OpenGLRenderer;
import gltools.sets.ColorSet;
import mesh.StaticMeshProvider;
import oglrenderer.GLLayer;
import oglrenderer.OGLContainer;
import oglrenderer.OGLContainerCopy;
import openfl.display.Sprite;
import openfl.events.RenderEvent;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class Main extends Sprite {
    var c:GLLayer<ColorSet>;
    var inited = false;

    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        var a = new OGLContainer();
        var b = new OGLContainerCopy();
        c = new GLLayer<ColorSet>();
        c.addView(new AssetMeshProvider<ColorSet>("Assets/my_tri", ColorSet.instance));
//        c.addView(new StaticMeshProvider<ColorSet>());

//        addChild(a);
//        addChild(new Pointer());
//        addChild(b);
//        addChild(c);
    }

    function render(e) {
        if (inited)
            return;
        trace("init");
        inited = true;
        var renderer:OpenGLRenderer = cast e.renderer;
        var gl:WebGLRenderContext = renderer.gl;
        c.init(gl, DummyShader.createDummyShader(gl), ColorSet.instance);
        addChild(c);
    }


}

class Pointer extends Sprite {
    public function new() {
        super();
        graphics.beginFill(0xff0040);
        graphics.drawCircle(100, 100, 100);
        graphics.endFill();
    }
}
