package data;
import haxe.io.Bytes;
abstract IndexCollection(Bytes) from Bytes to Bytes {
    public static inline var ELEMENT_SIZE = 2;
    public function new(size) {
        this = Bytes.alloc(ELEMENT_SIZE * size);
    }

    @:arrayAccess
    public inline function get(i) {
        return this.getUInt16(i * ELEMENT_SIZE);
    }

    @:arrayAccess
    public inline function set(i, val) {
        return this.setUInt16(i * ELEMENT_SIZE, val);
    }

    public var length(get, never):Int;

    inline function get_length():Int {
        return Std.int(this.length / ELEMENT_SIZE);
    }
}
