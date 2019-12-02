package datatools;
import data.DataType;
import haxe.io.Bytes;

@:forward(length)
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

    public inline function setTyped(type:DataType, offset, value:Dynamic) {
        switch type {
            case int32 : setInt32(offset, value);
            case uint8 : setUint8(offset, value);
            case uint16 : setUint16(offset, value);
            case float32 :
                setFloat32(offset, value);
        }
    }

//    public macro function set<T>()
}

