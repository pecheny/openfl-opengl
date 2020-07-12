package mesh.providers;
import datatools.VertValueProvider;
import datatools.ByteDataReader;
class TriPosProvider extends PosProvider {

    public function new(scale:Float, mirror = 1) {
        super();
        addVertex(-scale * mirror, -scale);
        addVertex(scale * mirror, -scale);
        addVertex(scale * mirror, scale);
    }


}

class QuadPosProvider extends PosProvider {
    public function new (x, y, w, h) {
        super();
        addVertex(x,y);
        addVertex(x+w,y);
        addVertex(x+w, y+h);
        addVertex(x, y+h);
    }

}

class PosProvider implements VertValueProvider {
    var vertx:Array<Float> = [];
    var verty:Array<Float> = [];

    public function new() {}

    public function addVertex(x:Float, y:Float) {
        vertx.push(x);
        verty.push(y);
    }

    public function getPos(idx, cmp) {
        var carr =
        if (cmp == 0)
            vertx
        else if (cmp == 1)
            verty
        else throw "Wrong1";
        return carr[idx];
    }

    public function getValue(v,c) {
        return getPos(v, c);
    }

    public function load(vbo:ByteDataReader, ofstX, ofstY, stride) {
        var vertCount = Std.int(vbo.length / stride);
        vertx = [];
        verty = [];
        for (vi in 0...vertCount) {
            var vo = stride * vi;
            vertx.push(vbo.getFloat32(vo + ofstX));
            verty.push(vbo.getFloat32(vo + ofstY));
        }
    }

    public function getVertCount() {
        return verty.length;
    }

}

class SolidColorProvider {
    var components:Array<Float> = [];

    public function new(r, g, b) {
        components.push(r);
        components.push(g);
        components.push(b);
        components.push(255);
    }

    public function getValue(_, cmp) {
        return components[cmp];
    }

    public static function fromInt(val:Int) {
        var r = val >> 16;
        var g = (val & 0x00ff00) >> 8;
        var b = (val & 0x0000ff);
        return new SolidColorProvider(r,g,b);
    }
}


