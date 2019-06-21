package ;
import mesh.AssetMeshProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.Instance2DVertexDataProvider;
import gltools.AttribAliases;
import gltools.sets.ColorSet;
import oglrenderer.GLLayer;
import oglrenderer.OGLContainer;
import oglrenderer.OGLContainerCopy;
import openfl.display.OpenGLRenderer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.RenderEvent;
import playground.FieldWithItems;
import shader.DummyShader;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class Main extends Sprite {
    var c:GLLayer<ColorSet>;
    var inited = false;
    var field:FieldWithItems;

    function createItem() {
        var pp = new TriPosProvider(0.5).getPos;
        var cp = new SolidColorProvider(2, 50, 200).getCC;
        var ip = vid -> vid;
        var ch = new Instance2DVertexDataProvider(ColorSet.instance);
        ch.adIndProvider(ip);
        ch.addDataSource(AttribAliases.NAME_POSITION, pp);
        ch.addDataSource(AttribAliases.NAME_CLOLOR_IN, cp);
        ch.fetchFertices(3, 3);
        ch.x = -0.2;
        return ch;
    }

    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, enterFrame);
        var a = new OGLContainer();
        var b = new OGLContainerCopy();
        c = new GLLayer<ColorSet>();
        field = new FieldWithItems();
        c.addView(new AssetMeshProvider<ColorSet>("Assets/my_tri", ColorSet.instance));
        c.addView(createItem());
        c.addView(field);
//        c.addView(new AssetMeshProvider<ColorSet>("Assets/blend_exp", ColorSet.instance));
//        var f = new StaticMeshProvider<ColorSet>();

//        addChild(a);
//        addChild(new Pointer());
//        addChild(b);
        addChild(c);
    }

    function enterFrame(e) {
        field.update(0.016);
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
