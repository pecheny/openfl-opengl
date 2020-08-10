package datatools;
import data.AttribSet;
import data.AttributeDescr;
import data.DataType;
class FloatValueWriter implements IValueWriter {
    var stride:Int;
    var offset:Int;
    var type:DataType;
    var target:ByteDataWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
        if (attr.type != DataType.float32)
            throw "Wrong writer for type " + attr.type;

        this.target = target;
        var compOffset = attr.offset + AttribSet.getGlSize(attr.type) * comp;
        this.offset = compOffset + offset;
        this.stride = stride;
        this.type = attr.type;
    }

    // todo write macro typed set for dataWriter
    public function setValue(vertIdx:Int, value:Float) {
        target.setFloat32(vertIdx * stride + offset, value);
    }

    public function getValue(vertIdx:Int) {
        var o = vertIdx * stride + offset;
        return target.toReader().getFloat32(o);
    }
}

class Uint8ValueWriter implements IValueWriter {
    var stride:Int;
    var offset:Int;
    var type:DataType;
    var target:ByteDataWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
        if (attr.type != DataType.uint8)
            throw "Wrong writer for type " + attr.type;

        this.target = target;
        var compOffset = attr.offset + AttribSet.getGlSize(attr.type) * comp;
        this.offset = compOffset + offset;
        this.stride = stride;
        this.type = attr.type;
    }

    // todo write macro typed set for dataWriter
    public function setValue(vertIdx:Int, value:Float) {
        target.setUint8(vertIdx * stride + offset, cast value);
    }

    public function getValue(vertIdx:Int) :Float {
        var o = vertIdx * stride + offset;
        return target.toReader().getUInt8(o);
    }
}
interface IValueWriter {

    public function setValue(vertIdx:Int, value:Float):Void;
    public function getValue(vertIdx:Int):Float;
}
class ValueWriter {

    public static function create(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0):IValueWriter {
        switch attr.type {
            case float32 : return new FloatValueWriter(target, attr, comp, stride, offset);
            case uint8 : return new Uint8ValueWriter(target, attr, comp, stride, offset);
            case _ : throw "not implemented yet";
        }
    }
}
//    var stride:Int;
//    var offset:Int;
//    var type:DataType;
//    var target:ByteDataWriter;
//
//    public static function create(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
//
//    }
//
//    function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
//        this.target = target;
//        var compOffset = attr.offset + AttribSet.getGlSize(attr.type) * comp;
//        this.offset = compOffset + offset;
//        this.stride = stride;
//        this.type = attr.type;
//    }
//
//    // todo write macro typed set for dataWriter
//    public function setValue(vertIdx:Int, value:T) {
//        target.setTyped(type, vertIdx * stride + offset, value);
//    }
//
//    public function getValue(vertIdx:Int) {
//        var o = vertIdx * stride + offset;
//        return switch type {
//            case int32 : target.toReader().getInt32(o);
//            case uint8 : target.toReader().getUInt8(o);
//            case uint16 : target.toReader().getUInt16(o);
//            case float32 :
//                target.toReader().getFloat32(o);
//        }
//    }
//}

class TransformValueWriter extends FloatValueWriter {
    var transform:Float -> Float;

    public function new(target:ByteDataWriter, attr:AttributeDescr, comp:Int, stride:Int, offset:Int = 0) {
        super(target, attr, comp, stride, offset);
        transform = passthrough;
    }

    function passthrough(val) return val;

    public function replaceTransform(newTransform) this.transform = newTransform;

    public function addTransformNode(t) {
        this.transform = (v) -> t(this.transform(v));
    }

    override public function setValue(vertIdx:Int, value:Float) {
        super.setValue(vertIdx, transform(value));
    }
}

