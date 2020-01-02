package datatools;
import data.DataType;
import data.AttributeDescr;
import data.AttribSet;
class ValueWriter<T> {
    var stride:Int;
    var offset:Int;
    var type:DataType;
    var target:ByteDataWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
        this.target = target;
        var compOffset = attr.offset + AttribSet.getGlSize(attr.type) * comp;
        this.offset = compOffset + offset;
        this.stride = stride;
        this.type = attr.type;
    }

    // todo write macro typed set for dataWriter
    public inline function setValue(vertIdx:Int, value:T) {
        target.setTyped(type, vertIdx * stride + offset, value);
    }
}

