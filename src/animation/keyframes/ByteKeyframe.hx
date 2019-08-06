package animation.keyframes;
import data.DataType;
import data.BytesView;
import haxe.io.Bytes;
class ByteKeyframe extends BytesView implements Keyframe {
    var time:Float;
    var vertCount:Int
    public function new(time, bytes:Bytes, offset:Int, stride:Int, numComponent:Int, componentType:DataType, vertCount:Int) {
        this.time = time;
        this.vertCount = vertCount;
        super(bytes, offset,stride, numComponent, componentType);
    }
    public function getTime():Float{
        return time;
    }

    public function getVertCount():Int {
        return vertCount;
    }
}
