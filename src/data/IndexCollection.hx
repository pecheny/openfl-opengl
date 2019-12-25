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

    public static function forQuads(count) {
        var ic = new IndexCollection(count * 6);
        for (i in 0...count) {
            var j = i*6;
            ic[j] =  i * 4;
            ic[j + 1] =  i * 4 + 1;
            ic[j + 2] =  i * 4 + 2;
            ic[j + 3] =  i * 4 ;
            ic[j + 4] =  i * 4 + 3;
            ic[j + 5] =  i * 4 + 2;
        }
        return ic;
    }

    public static function forQuadsOdd(count) {
        var ic = new IndexCollection(count * 6);
        for (i in 0...count) {
            var j = i*6;
            ic[j] =  i * 4;
            ic[j + 1] =  i * 4 + 1;
            ic[j + 2] =  i * 4 + 3;
            ic[j + 3] =  i * 4 ;
            ic[j + 4] =  i * 4 + 3;
            ic[j + 5] =  i * 4 + 2;
        }
        return ic;
    }
}
