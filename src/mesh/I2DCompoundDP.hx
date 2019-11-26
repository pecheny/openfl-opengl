package mesh;
import gltools.sets.ColorSet;
import data.IndexCollection;
import haxe.io.Bytes;
import data.AttribAliases;
import data.AttributeDescr;
import gltools.VertDataProvider;
import data.VertexAttribProvider;
import data.AttribSet;
class I2DCompoundTypedDP<T:AttribSet> extends I2DCompoundDP implements VertDataProvider<T>{
    public function new (attrs:T) {
        super(attrs);
    }
}

class I2DCompoundDP extends VertDataProviderBase  {
    var attrSources:Map<String, VertexAttribProvider> = new Map();
    var attributes:AttribSet;
    var posAtr:AttributeDescr;
    var posSource:VertexAttribProvider;
    var indProvider:Int -> Int;

    public dynamic function getX(){return 0;}
    public dynamic function getY(){return 0;}
    public dynamic function getScaleX(){return 1;}
    public dynamic function getScaleY(){return 1;}

    public function new(attrs:AttribSet) {
        posAtr = attrs.getDescr(AttribAliases.NAME_POSITION);
        attributes = attrs;
    }

    public function addDataSource(attrName:String, pr:VertexAttribProvider) {
        attrSources.set(attrName, pr);
    }

    public function adIndProvider(p:Int -> Int) {
        indProvider = p;
    }

    public function updatePositions() {
        for (vi in 0...vertCount) {
            setTyped(posAtr.type, getOffset(vi, 0, posAtr), getScaleX() * posSource(vi, 0) + getX());
            setTyped(posAtr.type, getOffset(vi, 1, posAtr), getScaleY() * posSource(vi, 1) + getY());
        }
    }


    public function updateAttribute(name) {
        if (name == AttribAliases.NAME_POSITION)
            return updatePositions();
        var posSource = attrSources.get(name);
        var posAtr = attributes.getDescr(name);
        for (vi in 0...vertCount) {
            for (c in 0...posAtr.numComponents)
            setTyped(posAtr.type, getOffset(vi, c, posAtr), posSource(vi, c) );
        }
    }

    public function fetchVertices(vertCount:Int, indCount:Int) {
        if (vertData == null || vertData.length != vertCount * attributes.stride) {
            vertData = Bytes.alloc(vertCount * attributes.stride);
        }
        this.posSource = attrSources.get(posAtr.name);
        this.vertCount = vertCount;
        this.indCount = indCount;
            for (atr in attributes.attributes) {
                updateAttribute(atr.name);
        }
        indData = new IndexCollection(indCount);
        for (i in 0...indCount) {
            var ind = indProvider(i);
            indData[i] = ind;
        }
    }

    inline function getOffset(vertIdx, cmpIdx, atr) {
        return attributes.stride * vertIdx + atr.offset + cmpIdx * AttribSet.getGlSize(atr.type);
    }

    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
        IndicesFetcher.gatherIndices(target, startFrom, offset, indData, getIndsCount());
    }


    // todo avoid exact set, put to app place
    public function toSeparated(cp:VertexAttribProvider) {
        var inds:IndexCollection = this.getInds();
        var data = this.getVerts();
        var posView = new datatools.BufferView(data, datatools.BufferView.wholeBytesOf(data), attributes.getView(AttribAliases.NAME_POSITION));
        var separated = new Instance2DVertexDataProvider(ColorSet.instance);
        separated.addDataSource(AttribAliases.NAME_POSITION, (v,c) -> {
            posView.getValue(inds[v], c);
        });
        separated.addDataSource(AttribAliases.NAME_COLOR_IN, (v,c) -> cp (Math.floor(v / 3), c));
        separated.adIndProvider( n-> n);
        separated.fetchVerticesAndIndices(inds.length , inds.length);
        return separated;
    }
}
