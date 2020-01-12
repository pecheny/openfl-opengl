package gltools;
import data.AttribSet;
import gltools.VertIndDataProvider.VertDataProvider;
import haxe.io.Bytes;
import gltools.VertDataTarget.RenderDataTarget;
class SimpleBlitRenderer<T:AttribSet> implements VertDataProvider<T> {
    var attributes:T;
    var vertData:Bytes;
    var len:Int;

    public function new(attrs:T, data:haxe.io.Bytes, vertCount:Int) {
        this.attributes = attrs;
        this.vertData = data;
        this.len = Std.int(data.length / attrs.stride);
    }

    public function setVertCount(l:Int) {
        len = l;
    }

    public function getVertsCount():Int {
        return len;
    }

    public function render(target:RenderDataTarget):Void {
        target.getBytes().blit(target.pos, vertData, 0, attributes.stride * getVertsCount());
    }
}

