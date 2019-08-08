package animation.serialization;
import haxe.io.Bytes;
import animation.keyframes.ByteKeyframe;
import data.AttributeView;
import data.DataTypeUtils;
import gltools.AttributeDescr;
import utils.ExtensibleBytes;
class AnimationSerializer {
    public function new() {
    }


    @:access(animation.Animation)
    @:access(animation.AnimationChannel)
    public function serialize(a:Animation) {
        var result:AnimationRecord = {
            channels:[],
            channelViews:[],
            data:""
        }
        var buffer = new ExtensibleBytes(16);
        var bufCapacity = 0;
        var bufferPosition = 0;
        function getChannelCapacity(ch:AnimationChannel, descr:AttributeDescr) {
            var vertCount = 0;
            for (k in ch.frames)
                vertCount += k.getVertCount();
            return vertCount * descr.numComponents * DataTypeUtils.getGlSize(descr.type);
        }

        for (i in 0...a.channels.length) {
            var ch = a.channels[i];
            var desc = a.descriptors[i];
            var vertSize = DataTypeUtils.getGlSize(desc.type) * desc.numComponents;
            var chRec:AnimationChannelRecord = {
                descr:Reflect.copy(desc),
                frames:[]
            }
            var view:AttributeView = {
                stride:vertSize,
                offset:0,
                numComponents:desc.numComponents,
                type:desc.type
            };
            var chCapacity = getChannelCapacity(ch, desc);
            bufCapacity += chCapacity;
            buffer.grantCapacity(bufCapacity);

            result.channels.push(chRec);
            result.channelViews.push({
                byteLength: chCapacity,
                byteOffset: bufferPosition
            });

            for (fr in ch.frames) {
                var count = fr.getVertCount();
                DataTypeUtils.writeVerts(buffer.bytes, fr.getValue, count, view, bufferPosition);
                chRec.frames.push({
                    vertCount:count,
                    time: fr.getTime()
                });
                bufferPosition += count * vertSize;
            }
        }

        result.data = haxe.crypto.Base64.encode(buffer.bytes);
        return result;
    }

    public function deserialize(data:AnimationRecord):Animation {
        var anim = new Animation();
        var buffer = haxe.crypto.Base64.decode(data.data);
        for (i in 0...data.channels.length) {
            var chRec = data.channels[i];
            var desc = chRec.descr;
            var vertSize = DataTypeUtils.getGlSize(desc.type) * desc.numComponents;
            var bview = data.channelViews[i];
            var ch = new AnimationChannel();
            var bufferPointer = bview.byteOffset;
            anim.addChannel(desc, ch);

            for (frRec in chRec.frames) {
                var size = frRec.vertCount * vertSize;
                var bytes = Bytes.alloc(size);
                bytes.blit(0, buffer, bufferPointer, size);
                bufferPointer += size;
                var kf = new ByteKeyframe(frRec.time, bytes, 0, vertSize, desc.numComponents, desc.type, frRec.vertCount);
                trace(kf.toString());
                ch.addKeyframe(kf);
            }

        }
        return anim;
    }
}

typedef AnimationRecord = {
    var channels:Array<AnimationChannelRecord>;
    var channelViews:Array<BufferView>;
    var data:String;
}

typedef KeyframeRecord = {
    var vertCount:Int;
    var time:Float;
}

typedef AnimationChannelRecord = {
    var descr:AttributeDescr;
    var frames:Array<KeyframeRecord>;
}

typedef BufferView = {
    var byteLength:Int;
    var byteOffset:Int;
}


