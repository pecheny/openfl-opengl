package playground;
import animation.Animation;
import animation.AnimationChannel;
import animation.keyframes.ProviderKeyframe;
import animation.serialization.AnimationSerializer;
import data.DataType;
import data.AttribAliases;
import data.AttribSet;
import gltools.sets.ColorSet;
import mesh.Instance2DVertexDataProvider;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import utils.AbstractEngine;
class AnimatedLoader extends AbstractEngine {
    var instance:Instance2DVertexDataProvider<ColorSet>;
    var anim:Animation;

    public function build(data:AnimationRecord) {
        var cp = new SolidColorProvider(2, 50, 50).getCC;
        var ip = vid -> vid;
        var view = new Instance2DVertexDataProvider(ColorSet.instance);
        view.adIndProvider(ip);
        view.addDataSource(AttribAliases.NAME_COLOR_IN, cp);
        var serializer = new AnimationSerializer();
        var danim = serializer.deserialize(data);
        this.anim = danim;
        for (i in 0...danim.channels.length) {
            var ch = danim.channels[i];
            var desc = anim.descriptors[i];
            view.addDataSource(desc.name, ch.getValue);
        }

        view.fetchFertices(3, 3);
        view.x = -0.2;
        instance = view;
        return view;
    }


    var t:Float = 0;
    var duration = 2.3;

    override public function update(t) {
        this.t += t;
        if (this.t > duration)
            this.t = 0;
        anim.setTime(this.t);
        instance.updatePositions();
    }
}
