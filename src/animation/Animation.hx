package animation;
import gltools.AttributeDescr;
class Animation {
    public var channels:Array<AnimationChannel> = [];
    public var descriptors:Array<AttributeDescr> = []; // todo replace public with accessors
    public function new() {
    }

    public function addChannel(descr:AttributeDescr, c:AnimationChannel) {
        channels.push(c);
        descriptors.push(descr);
    }

    public function setTime(t:Float) {
        for (ch in channels)
            ch.setTime(t);
    }

}
