package ;
import utils.EmbedLocalFile;
import data.AttribAliases;
import gltools.sets.ColorSet;
import mesh.AssetMeshProvider;
import mesh.Instance2DVertexDataProvider;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import oglrenderer.GLLayer;
import openfl.display.Sprite;
import openfl.events.Event;
import playground.AnimatedLoader;
import playground.FieldWithItems;
import shader.DummyShader;

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
        ch.addDataSource(AttribAliases.NAME_COLOR_IN, cp);
        ch.fetchFertices(3, 3);
        ch.x = -0.2;
        return ch;
    }

    public function new() {
        #if cpp
        new debugger.HaxeRemote(true, "localhost", 6972);
        #end
        super();
        addEventListener(Event.ENTER_FRAME, enterFrame);

        c = new GLLayer(ColorSet.instance, DummyShader.createDummyShader);
        c.addView(createItem());
        c.addView(new AssetMeshProvider<ColorSet>("Assets/blend_exp", ColorSet.instance));
//        c.addView(new AssetMeshProvider<ColorSet>("Assets/my_tri", ColorSet.instance));

        var d = new GLLayer(ColorSet.instance, DummyShader.createDummyShader);
        field = new FieldWithItems();
//        d.addView(field);
        d.addView(new AnimatedLoader().build(EmbedLocalFile.embedJsonAsset("animation.json")));
//        d.setViewport(100,100,100,100);
//        addChild(new Pointer());
//        addChild(c);
        addChild(d);


    }

    function enterFrame(e) {
        field.update(0.016);
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
