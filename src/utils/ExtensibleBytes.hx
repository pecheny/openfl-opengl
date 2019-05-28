package utils;
import haxe.io.Bytes;
class ExtensibleBytes {
    public var bytes(default, null):Bytes;
    var size:Int;

    public function new(size) {
        this.size = size;
        this.bytes = Bytes.alloc(size);
    }

    var step = 16;
    inline public function blit(pos:Int, src:Bytes, srcpos:Int, len:Int):Void {
        while (pos + len > size) {
            var b = Bytes.alloc(size + step);
            b.blit(0, bytes, 0, size);
            size+= step;
            bytes = b;
        }
        bytes.blit(pos, src, srcpos, len);
    }
}

