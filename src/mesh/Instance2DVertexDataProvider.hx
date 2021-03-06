package mesh;
import datatools.ExtensibleBytes;
import data.AttribAliases;
import data.AttribSet;
import data.IndexCollection;
import data.VertexAttribProvider;
import gltools.sets.ColorSet;
import gltools.VertIndDataProvider;


class Instance2DVertexDataProvider<T:AttribSet> extends VertDataProviderBase<T> implements VertIndDataProvider<T> {
    var indProvider:Int -> Int;

    public function new(attrs:T) {
        super(attrs);
    }

    public function adIndProvider(p:Int -> Int) {
        indProvider = p;
    }

    public function fetchVerticesAndIndices(vertCount:Int, indCount:Int) {
        fetchVertices(vertCount);
        fetchIndices(indCount);
    }

    function fetchIndices(indCount) {
        this.indCount = indCount;
        indData = new IndexCollection(indCount);
        for (i in 0...indCount) {
            var ind = indProvider(i);
            indData[i] = ind;
        }
    }

    public function with<T:AttribSet>(newSet:T, name, source):Instance2DVertexDataProvider<T>{
        this.attributes = cast newSet;
        attrSources = attrSources.with(name, source);
        fetchVertices(vertCount);
        return cast this;
    }

    public function gatherIndices(target:ExtensibleBytes, startFrom:Int, offset) {
        IndicesFetcher.gatherIndices(target, startFrom, offset, indData, getIndsCount());
    }


    // todo avoid exact set, put to app place
    public function toSeparated(cp:VertexAttribProvider) {
        var inds:IndexCollection = this.getInds();
        var data = this.getVerts();
        var posView = new datatools.BufferView<Float>(data, datatools.BufferView.wholeBytesOf(data), attributes.getView(AttribAliases.NAME_POSITION));
        var separated = new Instance2DVertexDataProvider(ColorSet.instance);
        separated.addDataSource(AttribAliases.NAME_POSITION, (v, c) -> {
            posView.getValue(inds[v], c);
        });
        separated.addDataSource(AttribAliases.NAME_COLOR_IN, (v, c) -> cp(Math.floor(v / 3), c));
        separated.adIndProvider(n -> n);
        separated.fetchVerticesAndIndices(inds.length, inds.length);
        return separated;
    }


    // well it suggested for exact goal: share providers, indices among instances with independend vertex data (containig merged transforms).
    @:access(mesh.Instance2DVertexDataProvider)
    @:access(mesh.VertexAttrProviderBase)
    @:access(mesh.VertexAttrDataProvider)
    public function clone() {
        var copy = new Instance2DVertexDataProvider(attributes);
        copy.indProvider = indProvider;
        copy.indData = indData;
        copy.indCount = indCount;
        copy.attrSources = cast attrSources;
        copy.fetchVertices(vertCount);
        return copy;
    }
}

