package datatools;
import data.AttribSet;
import data.AttributeDescr;
import data.DataType;
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
    public function setValue(vertIdx:Int, value:T) {
        target.setTyped(type, vertIdx * stride + offset, value);
    }

    public function getValue(vertIdx:Int) {
        var o = vertIdx * stride + offset;
         return switch type {
            case int32 : target.toReader().getInt32(o);
            case uint8 : target.toReader().getUInt8(o);
            case uint16 : target.toReader().getUInt16(o);
            case float32 :
                target.toReader().getFloat32(o);
        }
    }
}

class TransformValueWriter<T> extends ValueWriter<T> {
    var transform:T -> T;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
        super(target, attr, comp, stride, offset);
        transform = passthrough;
    }

    function passthrough(val) return val;

    public function replaceTransform(newTransform) this.transform = newTransform;

    public function addTransformNode(t) {
        this.transform = (v) -> t(this.transform(v));
    }

    override public function setValue(vertIdx:Int, value:T) {
        super.setValue(vertIdx, transform(value));
    }
}

