package mesh;
import data.AttribSet;
import data.AttribSources;
class VertexAttrDataProvider<T:AttribSet> extends VertexAttrProviderBase  {
    var attrSources:AttribSources<T> = new AttribSources<T>();
    var attributes:AttribSet;

    public function new(attrs) {
        this.attributes = attrs;
    }

    public function updateAttribute(name) {
        var posSource = attrSources.get(name);
        var posAtr = attributes.getDescr(name);
        for (vi in 0...vertCount) {
            for (c in 0...posAtr.numComponents)
                setTyped(posAtr.type, getOffset(vi, c, posAtr), posSource(vi, c));
        }
    }


    public function fetchVertices(vertCount:Int) {
        this.vertCount = vertCount;

    }

     inline function getOffset(vertIdx, cmpIdx, atr) {
        return attributes.stride * vertIdx + atr.offset + cmpIdx * AttribSet.getGlSize(atr.type);
    }
}
