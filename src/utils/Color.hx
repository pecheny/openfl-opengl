package utils;
class Color {
    public var r:Float;
    public var g:Float;
    public var b:Float;

    public function new(r, g, b) {
        this.r = r;
        this.b = b;
        this.g = g;
    }

    public function set(r, g, b) {
        this.r = r;
        this.b = b;
        this.g = g;
    }

    public function fromInt(val:Int) {
        r = val >> 16;
        g = (val & 0x00ff00) >> 8;
        b = (val & 0x0000ff);
    }

    function toString() {
        return "[" + r  + " " + g  + " " + b  + "]";
    }
}
