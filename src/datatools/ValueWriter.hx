package datatools;
import data.DataType;
import data.AttributeDescr;
import data.AttribSet;
class ValueWriter<T> {
    var stride:Int;
    var compOffset:Int;
    var type:DataType;
    var target:ByteDataWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int) {
        this.target = target;
        compOffset = attr.offset + AttribSet.getGlSize(attr.type) * comp;
        this.stride = stride;
        this.type = attr.type;
    }

    // todo write macro typed set for dataWriter
    public inline function setValue(vertIdx:Int, value:T) {
        target.setTyped(type, vertIdx * stride + compOffset, value);
    }
}

