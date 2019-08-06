package playground;
import data.DataType;
import gltools.AttribSet;
import animation.Animation;
import animation.AnimationChannel;
import animation.keyframes.ProviderKeyframe;
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


        var cp = new SolidColorProvider(2, 50, 50).getCC;
        var ip = vid -> vid;
        var view = new Instance2DVertexDataProvider(ColorSet.instance);
        view.adIndProvider(ip);
//        view.addDataSource(AttribAliases.NAME_POSITION, posChannel.getValue);
        view.addDataSource(AttribAliases.NAME_COLOR_IN, cp);

        var anim = createAnimation();
        for (i in 0...anim.channels.length) {
            var ch = anim.channels[i];
            var desc = anim.descriptors[i];
            view.addDataSource(desc.name, ch.getValue);
        }


        view.fetchFertices(3, 3);
        view.x = -0.2;
        instance = view;
        return view;
    }

    function createAnimation() {
        posChannel = new AnimationChannel();
        posChannel.addKeyframe(new ProviderKeyframe(0, new TriPosProvider(0.5).getPos, 3));
        posChannel.addKeyframe(new ProviderKeyframe(1, new TriPosProvider(0.7).getPos, 3));
        posChannel.addKeyframe(new ProviderKeyframe(2, new TriPosProvider(0.5).getPos, 3));
        var atrSet = new AttribSet();
        atrSet.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
        var anim = new Animation();
        anim.addChannel(atrSet.attributes[0], posChannel);
        return anim;
    }

    var t:Float = 0;
    var duration = 2.3;

    override public function update(t) {
        this.t += t;
        if (this.t > duration)
            this.t = 0;
        posChannel.setTime(this.t);
        instance.updatePositions();
    }
}
