package data;
import gltools.AttribSet;
import gltools.AttributeState.DataType;
import haxe.io.Bytes;
@:keep
class BytesView {
    var bytes:Bytes;
    var offset:Int;
    var stride:Int;
    var numComponent:Int;
    var componentType:DataType;
    var componentSize:Int;

    public function new(bytes:Bytes, offset:Int, stride:Int, numComponent:Int, componentType:DataType) {
        this.bytes = bytes;
        this.offset = offset;
        this.stride = stride;
        this.numComponent = numComponent;
        this.componentType = componentType;
        componentSize = AttribSet.getGlSize(componentType);
    }

    public function getValue(vertId, compId){
        return AttribSet.getValue(bytes, componentType, vertId*stride  + compId * componentSize);
    }
}
