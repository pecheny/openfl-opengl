package mesh;
import data.IndexCollection;
import gltools.AttribAliases;
import gltools.AttribSet;
import gltools.AttributeDescr;
import gltools.VertDataProvider;
import haxe.io.Bytes;
class Instance2DVertexDataProvider<T:AttribSet> extends VertDataProviderBase implements VertDataProvider<T> {
    var attrSources:Map<String, VertexAttribProvider> = new Map();
    var attributes:AttribSet;
    public var x:Float = 0;
    public var y:Float = 0;
    var posAtr:AttributeDescr;
    var posSource:VertexAttribProvider;
    var indProvider:Int -> Int;

    public function new(attrs:T) {
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
            setTyped(posAtr.type, getOffset(vi, 0, posAtr), posSource(vi, 0) + x);
            setTyped(posAtr.type, getOffset(vi, 1, posAtr), posSource(vi, 1) + y);
        }
    }


    public function updateAttribute(name) {
        var posSource = attrSources.get(name);
        var posAtr = attributes.getDescr(name);
        for (vi in 0...vertCount) {
            setTyped(posAtr.type, getOffset(vi, 0, posAtr), posSource(vi, 0) + x);
            setTyped(posAtr.type, getOffset(vi, 1, posAtr), posSource(vi, 1) + y);
        }
    }

    public function fetchFertices(vertCount:Int, indCount:Int) {
        vertData = Bytes.alloc(vertCount * attributes.stride);
        this.posSource = attrSources.get(posAtr.name);
        this.vertCount = vertCount;
        this.indCount = indCount;
        for (i in 0...vertCount) {
            for (atr in attributes.attributes) {
                for (cmp in 0...atr.numComponents) {
                    var value:Dynamic = attrSources.get(atr.name)(i, cmp);
                    var offset = getOffset(i, cmp, atr);
                    setTyped(atr.type, offset, value);
//                    trace('set ${atr.name}:${atr.type}} $value at $i[$cmp]');
                }
            }
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

//    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
//        for (i in 0...getIndsCount()) {
//            var locInd = indData.toReader().getUInt16(i * UInt16Array.BYTES_PER_ELEMENT);
//            target[i + startFrom] = locInd + offset;
//        }
//    }

}
