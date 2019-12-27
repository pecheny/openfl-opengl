package mesh;
import gltools.VertDataTarget.RenderDataTarget;
import data.AttribSet;
import data.AttribSources;
import data.VertexAttribProvider;
import haxe.io.Bytes;
class VertexAttrDataProvider<T:AttribSet> extends VertexAttrProviderBase {
    var attrSources:AttribSources<T> = new AttribSources<T>();
    var attributes:T;

    public function new(attrs) {
        this.attributes = attrs;
    }

    public function addDataSource(attrName:String, pr:VertexAttribProvider) {
        attrSources.set(attrName, pr);
    }

    public function getSources():AttribSources<T> {
        return attrSources.copy();
    }

    public function updateAttribute(name) {
        var posSource = attrSources.get(name);
        var posAtr = attributes.getDescr(name);
        for (vi in 0...vertCount) {
            for (c in 0...posAtr.numComponents)
                setTyped(posAtr.type, getOffset(vi, c, posAtr), posSource(vi, c));
        }
    }

    public function render(target:RenderDataTarget){
        target.getBytes().blit(target.pos, vertData, 0, attributes.stride * getVertsCount());
    }

    public function fetchVertices(vertCount:Int) {
        if (vertData == null || vertData.length < vertCount * attributes.stride)
            vertData = Bytes.alloc(vertCount * attributes.stride);
        this.vertCount = vertCount;
        for (atr in attributes.attributes) {
            updateAttribute(atr.name);
        }
    }

    inline function getOffset(vertIdx, cmpIdx, atr) {
        return attributes.stride * vertIdx + atr.offset + cmpIdx * AttribSet.getGlSize(atr.type);
    }
}
