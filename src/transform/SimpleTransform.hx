package transform;
import datatools.VertValueProvider;
class SimpleTransform implements VertValueProvider {
    var pos:Array<Float> = [0, 0];
    var size:Array<Float> = [1, 1];
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var scaleX(get, set):Float;
    public var scaleY(get, set):Float;
    var source:VertValueProvider;

    public function new(source) {
        this.source = source;
    }

    public function getValue(v:Int, c:Int):Float {
        return pos[c] + size[c] * source.getValue(v,c);
    }

    public function toString() {
        return '[x:$x, y:$y, sx:$scaleX, sy:$scaleY]';
    }

    inline function get_y():Float {
        return pos[1];
    }

    inline function set_y(value:Float):Float {
        return pos[1] = value;
    }

    inline function get_x():Float {
        return pos[0];
    }

    inline function set_x(value:Float):Float {
        return pos[0] = value;
    }

    inline function get_scaleX():Float {
        return size[0];
    }

    inline function set_scaleX(value:Float):Float {
        return size[0] = value;
    }

    inline function get_scaleY():Float {
        return size[1];
    }

    inline function set_scaleY(value:Float):Float {
        return size[1] = value;
    }
}
