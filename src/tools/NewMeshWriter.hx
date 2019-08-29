package tools;
import gltools.sets.PosSet;
import data.AttribAliases;
import data.AttribSet;
import data.AttributeDescr;
import data.AttributeView.AttrViewInstances;
import data.DataType;
import data.IndexCollection;
import data.VertexAttribProvider;
import datatools.DataTypeUtils;
import datatools.ExtensibleBytes;
import gltools.sets.ColorSet;
import mesh.Instance2DVertexDataProvider;
import mesh.serialization.data.MeshRecord;
class NewMeshWriter {
    var sources:Map<String, VertexAttribProvider> = new Map();
    var descriptors:Map<String, AttributeDescr> = new Map();
    var indProvider:Int -> Int;

    public function new() {
    }

    public function addSource(atrName:String, numComponents:Int, type:DataType, prov:VertexAttribProvider) {
        sources.set(atrName, prov);
        descriptors.set(atrName, AttribSet.createAttribute(atrName, numComponents, type));
    }

    public function addIndProvider(p:Int -> Int) {
        this.indProvider = p;
    }

    public function saveVertsAndInds(filename:String, vertCcount:Int, indCount:Int) {
        var rec:MeshRecord = {
            data:"",
            channels:[]
        }
        var b = new BufferWrapper();
        writeAttributes(rec, b, vertCcount);
        writeIndices(rec, b, indCount);
        rec.data = haxe.crypto.Base64.encode(b.buffer.bytes);
        return rec;
    }

    public function saveVertsOnly(filename:String, count:Int) {
        var rec:MeshRecord = {
            data:"",
            channels:[]
        }
        var b = new BufferWrapper();
        writeAttributes(rec, b, count);
        rec.data = haxe.crypto.Base64.encode(b.buffer.bytes);
        return rec;
    }

    function writeIndices(rec:MeshRecord, b:BufferWrapper, indCount) {
        var indCapacity = IndexCollection.ELEMENT_SIZE * indCount;
        rec.indices = {
            byteLength: indCapacity,
            byteOffset: b.bufferPosition
        }
        b.bufCapacity += indCapacity;
        var inds = new IndexCollection(indCount);
        for (i in 0...indCount) {
            inds[i] = indProvider(i);
        }
        b.buffer.blit(b.bufferPosition, inds, 0, inds.length * IndexCollection.ELEMENT_SIZE);
    }

    function writeAttributes(rec:MeshRecord, b:BufferWrapper, vertCcount) {
        for (name in descriptors.keys()) {
            var descr = descriptors.get(name);
            var provider = sources.get(name);
            var view = DataTypeUtils.descToView(descr);
            var chCapacity = view.stride * vertCcount;
            rec.channels.push(
                {
                    descr:descr,
                    view:
                    {
                        byteLength: chCapacity,
                        byteOffset: b.bufferPosition
                    }}
            );
            b.bufCapacity += chCapacity;
            b.buffer.grantCapacity(b.bufCapacity);
            DataTypeUtils.writeVerts(b.buffer.bytes, provider, vertCcount, view, b.bufferPosition);
            b.bufferPosition += vertCcount * view.stride;
        }
    }


// todo  make this metod generic by AttSet and provide it attFactories contex as an argument
    public static function deserialize(data:MeshRecord):Instance2DVertexDataProvider {
        var bytes = haxe.crypto.Base64.decode(data.data);
        var mesh = new Instance2DVertexDataProvider(PosSet.instance);
        var vertCount = 0;

        for (ch in data.channels) {
            var accessor = new datatools.BufferView(bytes, ch.view, DataTypeUtils.descToView(ch.descr));
            vertCount = accessor.length;
            mesh.addDataSource(ch.descr.name, accessor.getValue);
        }

        if (data.indices != null) {
            var inds = new datatools.BufferView(bytes, data.indices, AttrViewInstances.getIndView());
            mesh.adIndProvider(inds.getMonoValue);
            mesh.fetchFertices(vertCount, inds.length);
        } else {
            mesh.adIndProvider(n -> n);
            mesh.fetchFertices(vertCount, vertCount);
        }
        return mesh;
    }


}

class BufferWrapper {
    public var buffer = new ExtensibleBytes(16);
    public var bufCapacity = 0;
    public var bufferPosition = 0;

    public function new() {}
}
