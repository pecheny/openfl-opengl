package mesh;
import data.AttribAliases;
import data.AttribSet;
import data.AttribSources;
import data.AttributeDescr;
import data.IndexCollection;
import data.VertexAttribProvider;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;
import haxe.io.Bytes;
class Instance2DVertexDataProvider<T:AttribSet> extends VertDataProviderBase<T> implements VertDataProvider<T>{
    public var x:Float = 0;
    public var y:Float = 0;
    public var scaleX:Float = 1;
    public var scaleY:Float = 1;
    var posAtr:AttributeDescr;
    var posSource:VertexAttribProvider;
    var indProvider:Int -> Int;

    public function new(attrs:T) {
        if (attrs.hasAttr(AttribAliases.NAME_POSITION))
            posAtr = attrs.getDescr(AttribAliases.NAME_POSITION);
        super(attrs);
    }

    public function addDataSource(attrName:String, pr:VertexAttribProvider) {
        attrSources.set(attrName, pr);
    }

    public function adIndProvider(p:Int -> Int) {
        indProvider = p;
    }

    public function updatePositions() {
        for (vi in 0...vertCount) {
            setTyped(posAtr.type, getOffset(vi, 0, posAtr), scaleX * posSource(vi, 0) + x);
            setTyped(posAtr.type, getOffset(vi, 1, posAtr), scaleY * posSource(vi, 1) + y);
        }
    }

    public function getSources():AttribSources<T> {
        return attrSources.copy();
    }

    override public function updateAttribute(name) {
        if (name == AttribAliases.NAME_POSITION)
            return updatePositions();
        return super.updateAttribute(name);
    }

    public function fetchFertices(vertCount:Int, indCount:Int) {
        vertData = Bytes.alloc(vertCount * attributes.stride);
        if (posAtr != null)
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



    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
        IndicesFetcher.gatherIndices(target, startFrom, offset, indData, getIndsCount());
    }


    // todo avoid exact set, put to app place
    public function toSeparated(cp:VertexAttribProvider) {
        var inds:IndexCollection = this.getInds();
        var data = this.getVerts();
        var posView = new datatools.BufferView(data, datatools.BufferView.wholeBytesOf(data), attributes.getView(AttribAliases.NAME_POSITION));
        var separated = new Instance2DVertexDataProvider(ColorSet.instance);
        separated.addDataSource(AttribAliases.NAME_POSITION, (v, c) -> {
            posView.getValue(inds[v], c);
        });
        separated.addDataSource(AttribAliases.NAME_COLOR_IN, (v, c) -> cp(Math.floor(v / 3), c));
        separated.adIndProvider(n -> n);
        separated.fetchFertices(inds.length, inds.length);
        return separated;
    }
}
