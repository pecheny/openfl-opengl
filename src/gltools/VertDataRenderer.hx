package gltools;
import data.AttribSet;
import haxe.io.Bytes;
import gltools.VertDataProvider.VerticesBuffer;
import gltools.VertDataTarget.RenderDataTarget;
class VertDataRenderer<T:AttribSet> {
    var lastPos:Int;
    public var dirty = true;
    var attributes:T;
    var source:VertDataProvider<T>;

    public function new(set:T, source:VertDataProvider<T>) {
        this.attributes = set;
        this.source = source;
    }

    public function getVertsCount():Int {
        return source.getVertsCount();
    }

    public function getInds():Bytes {
        return source.getInds();
    }

    public function getIndsCount():Int {
        return source.getIndsCount();
    }

    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset:Int):Void {
        source.gatherIndices(target, startFrom, offset);
    }


    public function render(target:RenderDataTarget) {
        var needRender = dirty || (lastPos != target.pos);
        if (needRender){
            target.grantCapacity(target.pos + source.getVertsCount() * attributes.stride);
            source.render(target);
            lastPos = target.pos;
        }
    }
}

