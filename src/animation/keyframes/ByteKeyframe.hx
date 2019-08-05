package animation.keyframes;
import data.BytesView;
import haxe.io.Bytes;
import gltools.AttributeState.DataType;
class ByteKeyframe extends BytesView implements Keyframe {
    var time:Float;
    public function new(time, bytes:Bytes, offset:Int, stride:Int, numComponent:Int, componentType:DataType) {
        this.time = time;
        super(bytes, offset,stride, numComponent, componentType);
    }
    public function getTime():Float{
        return time;
    }
}
