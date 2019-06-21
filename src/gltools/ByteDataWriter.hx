package gltools;
import haxe.io.Bytes;
import lime.utils.ArrayBufferView.ArrayBufferIO;
abstract ByteDataWriter(Bytes) to Bytes from Bytes to ByteDataReader {
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

    public inline function toReader():ByteDataReader return this;
//    @:access(lime.utils.ArrayBufferView)
//    public static inline function fromBuffer(buffer:ArrayBuffer) {
//        var buf = new ArrayBufferView(null, None);
//        buf.initBuffer(buffer);
//        return new NativeDataContainer(buf);
//    }
}

