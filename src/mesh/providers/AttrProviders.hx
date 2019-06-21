package mesh.providers;
import gltools.ByteDataReader;
class TriPosProvider extends PosProvider {

    public function new(scale:Float, mirror = 1) {
        super();
        addVertex(-scale * mirror, -scale);
        addVertex(scale * mirror, -scale);
        addVertex(scale * mirror, scale);
    }


}
class PosProvider {
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

}

class SolidColorProvider {
    var components:Array<Float> = [];

    public function new(r, g, b) {
        components.push(r);
        components.push(g);
        components.push(b);
        components.push(255);
    }

    public function getCC(_, cmp) {
        return components[cmp];
    }
}


