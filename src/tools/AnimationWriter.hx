package tools;
import animation.Animation;
import animation.AnimationChannel;
import data.DataType;
import data.AttribSet;
class AnimationWriter {
    public function new() {
    }

    public function createChannel(anim:Animation, atrName:String, numComponents:Int, type:DataType) {
        var posChannel = new AnimationChannel();
//            posChannel.addKeyframe(new ProviderKeyframe(0, new TriPosProvider(0.5).getPos, 3));
//            posChannel.addKeyframe(new ProviderKeyframe(1, new TriPosProvider(0.7).getPos, 3));
//            posChannel.addKeyframe(new ProviderKeyframe(2, new TriPosProvider(0.5).getPos, 3));
        var atrSet = new AttribSet();
        atrSet.addAttribute(atrName, numComponents, type);
        anim.addChannel(atrSet.attributes[0], posChannel);
        return posChannel;
    }

    public function saveData(data:Dynamic, file:String) {
        var stream = sys.io.File.write(file);
        stream.writeString(haxe.Json.stringify(data, null, " "));
        stream.close();
    }
}
