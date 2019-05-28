package gltools;
import haxe.io.Bytes;
import lime.utils.ArrayBufferView.ArrayBufferIO;
class VertexBuilder {
    var data:ByteDataWriter;
    var a:AttribSet;

    public function new(a:AttribSet) {
        this.a = a;
    }

    public function setTarget(data:Bytes) {
        this.data = data;
        return this;
    }

    public function getData():Bytes return data;

    public function fetchFertices(vertCount:Int) {
        for (i in 0...vertCount) {
            for (atr in a.attributes) {
                trace(atr.name);
                for (cmp in 0...atr.numComponents) {
                    var value = setters.get(atr.name)(i, cmp);
                    var offset = a.stride * i + atr.offset + cmp * AttribSet.getGlSize(atr.type);
                    trace(atr.type);
                    switch atr.type {
//            case int8 : data.setInt8(offset, value);
                        case int16 : data.setInt16(offset, value);
                        case int32 : data.setInt32(offset, value);
                        case uint8 : data.setUint8(offset, value);
                        case uint16 : data.setUint16(offset, value);
                        case uint32 : data.setUint32(offset, value);
                        case float32 : data.setFloat32(offset, value);
                    }
                }
            }
        }
        trace("done");
    }

//    function setValue(idx, name) {}

    var setters:Map<String, Int -> Int -> Dynamic> = new Map();

    public function regSetter(attrDesc:String, setter:Int -> Int -> Dynamic) {
        setters.set(attrDesc,  setter);
    }

}

interface ValueProvider<T> {
    function getValue(vertIdx:Int):T;
}
abstract ByteDataWriter(Bytes) to Bytes from Bytes {
    inline function new(val) this = val;

    public inline function setInt8(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt8(this, byteOffset, value);

    public inline function setInt16(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt16(this, byteOffset, value);

    public inline function setInt32(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt32(this, byteOffset, value);

    public inline function setUint8(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint8(this, byteOffset, value);

    public inline function setUint16(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint16(this, byteOffset, value);

    public inline function setUint32(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint32(this, byteOffset, value);

    public inline function setFloat32(byteOffset:Int, value:Float)
    ArrayBufferIO.setFloat32(this, byteOffset, value);

//    @:access(lime.utils.ArrayBufferView)
//    public static inline function fromBuffer(buffer:ArrayBuffer) {
//        var buf = new ArrayBufferView(null, None);
//        buf.initBuffer(buffer);
//        return new NativeDataContainer(buf);
//    }
}