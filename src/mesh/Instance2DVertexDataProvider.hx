package mesh;
import data.AttribAliases;
import data.AttribSet;
import data.AttributeDescr;
import data.IndexCollection;
import data.VertexAttribProvider;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;


class Instance2DVertexDataProvider<T:AttribSet> extends VertDataProviderBase<T> implements VertDataProvider<T> {
    public var transform(default, null):PosComponet<T>;

    var indProvider:Int -> Int;

    public function new(attrs:T) {
        super(attrs);
        transform = new PosComponet(this);
    }

    public function adIndProvider(p:Int -> Int) {
        indProvider = p;
    }

    override public function updateAttribute(name) {
        if (name == AttribAliases.NAME_POSITION)
            return transform.updatePositions();
        return super.updateAttribute(name);
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
        separated.fetchVerticesAndIndices(inds.length, inds.length);
        return separated;
    }
}
class PosComponentBase {
    public var x:Float = 0;
    public var y:Float = 0;
    public var scaleX:Float = 1;
    public var scaleY:Float = 1;

    public function toString() {
        return '[x:$x, y:$y, sx:$scaleX, sy:$scaleY]';
    }
}

@:access(mesh.VertexAttrDataProvider)
class PosComponet<T:AttribSet> extends PosComponentBase{
    var target:VertexAttrDataProvider<T>;
    var posAtr:AttributeDescr;
    var posSource:VertexAttribProvider;

    public function new(target:VertexAttrDataProvider<T>) {
        this.target = target;
        posAtr = target.attributes.getDescr(AttribAliases.NAME_POSITION);
    }

    public function updatePositions() {
        if (posSource == null)
            this.posSource = target.attrSources.get(posAtr.name);
        for (vi in 0...target.vertCount) {
            target.setTyped(posAtr.type, target.getOffset(vi, 0, posAtr), scaleX * posSource(vi, 0) + x);
            target.setTyped(posAtr.type, target.getOffset(vi, 1, posAtr), scaleY * posSource(vi, 1) + y);
        }
    }
}
