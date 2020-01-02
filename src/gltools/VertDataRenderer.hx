package gltools;
import gltools.VertIndDataProvider.IndexProvider;
import gltools.VertIndDataProvider.VertDataProvider;
import data.AttribSet;
import datatools.ExtensibleBytes;
import gltools.VertDataTarget.RenderDataTarget;
import haxe.io.Bytes;
class VertDataRenderer<T:AttribSet> implements VertIndDataProvider<T> {
    var lastPos:Int;
    public var dirty = true;
    var attributes:T;
    var source:VertDataProvider<T>;
    var inds:IndexProvider;

    public function new(set:T, vertSource:VertDataProvider<T>,indSource:IndexProvider) {
        this.attributes = set;
        this.source = vertSource;
        this.inds = indSource;
    }

    public function getVertsCount():Int {
        return source.getVertsCount();
    }

    public function getInds():Bytes {
        return inds.getInds();
    }

    public function getIndsCount():Int {
        return inds.getIndsCount();
    }

    public function gatherIndices(target:ExtensibleBytes, startFrom:Int, offset:Int):Void {
        inds.gatherIndices(target, startFrom, offset);
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

