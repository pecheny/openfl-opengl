package data;
import data.AttribSet;
import haxe.io.Bytes;
@:keep
class BytesView {
    var bytes:Bytes;
    var offset:Int;
    var stride:Int;
    var numComponent:Int;
    var componentType:DataType;
    var componentSize:Int;
    var startFrom:Int;

    public function new(bytes:Bytes, offset:Int, stride:Int, numComponent:Int, componentType:DataType, startFrom:Int) {
        this.bytes = bytes;
        this.offset = offset;
        this.stride = stride;
        this.numComponent = numComponent;
        this.componentType = componentType;
        this.startFrom = startFrom;
        componentSize = AttribSet.getGlSize(componentType);
    }

    public function getValue(vertId, compId){
        return AttribSet.getValue(bytes, componentType, startFrom + offset + vertId*stride  + compId * componentSize);
    }
}
