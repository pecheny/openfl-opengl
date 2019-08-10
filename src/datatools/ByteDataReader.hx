package datatools;
import haxe.io.Bytes;
@:forward
abstract ByteDataReader (Bytes) to Bytes from Bytes {
    inline function new(val) this = val;

    public inline function getInt32(byteOffget:Int)
        return this.getInt32(byteOffget);

    public inline function getUInt16(byteOffget:Int)
        return this.getUInt16(byteOffget);

    public inline function getFloat32(byteOffget:Int)
     return this.getFloat(byteOffget);

    public inline function getUInt8(pos)
        return this.get(pos);

}
