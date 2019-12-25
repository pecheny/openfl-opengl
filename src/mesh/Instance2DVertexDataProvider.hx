package mesh;
import data.AttribAliases;
import data.AttribSet;
import data.IndexCollection;
import data.VertexAttribProvider;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;


class Instance2DVertexDataProvider<T:AttribSet> extends VertDataProviderBase<T> implements VertDataProvider<T> {
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
        this.attributes = newSet;
        attrSources = attrSources.with(name, source);
        fetchVertices(vertCount);
        return cast this;
    }

    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
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
}


interface Transform {
    function getValue(vertId:Int, cmpId:Int):Float;
}

