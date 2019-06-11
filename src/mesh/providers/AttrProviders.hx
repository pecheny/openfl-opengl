package mesh.providers;
class TriPosProvider extends PosProvider {

    public function new(scale, mirror = 1) {
        super();
        addVertex(-scale * mirror, -scale);
        addVertex(scale * mirror, -scale);
        addVertex(scale * mirror, scale);
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
}
class PosProvider {
    var vertx:Array<Float> = [];
    var verty:Array<Float> = [];

    public function new() {}

    public function addVertex(x, y) {
        vertx.push(x);
        verty.push(y);
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
        trace(cmp);
        return components[cmp];
    }
}


