package playground;
import animation.keyframes.ProviderKeyframe;
import animation.AnimationChannel;
import gltools.AttribAliases;
import gltools.sets.ColorSet;
import mesh.Instance2DVertexDataProvider;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import utils.AbstractEngine;
class AnimatedTri extends AbstractEngine {
    var posChannel:AnimationChannel;
    var instance:Instance2DVertexDataProvider<ColorSet>;

    public function build() {
        posChannel = new AnimationChannel();
        posChannel.addKeyframe(new ProviderKeyframe(0, new TriPosProvider(0.5).getPos));
        posChannel.addKeyframe(new ProviderKeyframe(1, new TriPosProvider(0.7).getPos));
        posChannel.addKeyframe(new ProviderKeyframe(2, new TriPosProvider(0.5).getPos));

        var cp = new SolidColorProvider(2, 50, 50).getCC;
        var ip = vid -> vid;
        var ch = new Instance2DVertexDataProvider(ColorSet.instance);
        ch.adIndProvider(ip);
        ch.addDataSource(AttribAliases.NAME_POSITION, posChannel.getValue);
        ch.addDataSource(AttribAliases.NAME_COLOR_IN, cp);
        ch.fetchFertices(3, 3);
        ch.x = -0.2;
        instance = ch;
        return ch;
    }

    var t:Float = 0;
    var duration = 2.3;

    override public function update(t){
        this.t += t;
        if (this.t > duration)
            this.t = 0;
        posChannel.setTime(this.t);
        instance.updatePositions();
    }
}
