package mesh.providers;
import hxColorToolkit.spaces.RGB;
class ColorArrayProvider {
    var colors:Array<RGB>;
    public function new(colors) {
        this.colors = colors;
    }

    public function getValue(v, c) {
//        if (c == 3)
//            return 254.;
        if (c == 3)
            return 255.;
//        return (v % 3 == 0 )? 0. : 255.;
//            trace(colors[v].getValue(c));
        return colors[v].getValue(c);
    }
}
