package gltools;
import haxe.io.Bytes;
import lime.utils.ArrayBufferView.ArrayBufferIO;
@:forward()
abstract ByteDataReader (Bytes) to Bytes from Bytes {
    inline function new(val) this = val;

    public inline function getInt8(byteOffget:Int)
     return ArrayBufferIO.getInt8(this, byteOffget);

    public inline function getInt16(byteOffget:Int)
     return ArrayBufferIO.getInt16(this, byteOffget);

    public inline function getInt32(byteOffget:Int)
     return ArrayBufferIO.getInt32(this, byteOffget);

    public inline function getUint8(byteOffget:Int)
     return ArrayBufferIO.getUint8(this, byteOffget);

    public inline function getUint16(byteOffget:Int)
     return ArrayBufferIO.getUint16(this, byteOffget);

    public inline function getUint32(byteOffget:Int)
     return ArrayBufferIO.getUint32(this, byteOffget);

    public inline function getFloat32(byteOffget:Int)
     return ArrayBufferIO.getFloat32(this, byteOffget);

}

