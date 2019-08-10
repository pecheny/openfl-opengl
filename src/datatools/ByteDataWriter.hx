package datatools;
import haxe.io.Bytes;

abstract ByteDataWriter(Bytes) to Bytes from Bytes to ByteDataReader {
    inline function new(val) this = val;

    public inline function setInt32(byteOffset:Int, value:Int)
    this.setInt32(byteOffset, value);

    public inline function setUint8(byteOffset:Int, value:Int)
    this.set(byteOffset, value);

    public inline function setUint16(byteOffset:Int, value:Int)
    this.setUInt16(byteOffset, value);

    public inline function setFloat32(byteOffset:Int, value:Float)
    this.setFloat(byteOffset, value);

    public inline function toReader():ByteDataReader return this;

}

