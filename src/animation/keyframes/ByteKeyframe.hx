package animation.keyframes;
import data.BytesView;
import data.DataType;
import haxe.io.Bytes;
class ByteKeyframe extends BytesView implements Keyframe {
    var time:Float;
    var vertCount:Int;

    public function new(time, bytes:Bytes, offset:Int, stride:Int, numComponent:Int, componentType:DataType, vertCount:Int) {
        this.time = time;
        this.vertCount = vertCount;
        super(bytes, offset, stride, numComponent, componentType, 0);
    }

    public function getTime():Float {
        return time;
    }

    public function getVertCount():Int {
        return vertCount;
    }

    public function toString() {
        var r = "";
        for (i in 0...vertCount) {
            r += "[ ";
            for (c in 0...numComponent) {
                r+= getValue(i, c) + ", ";
            }
            r += "], ";
        }
        return r;
    }
}
