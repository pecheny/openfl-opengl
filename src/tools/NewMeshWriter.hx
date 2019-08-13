package tools;
import data.AttribSet;
import data.AttributeDescr;
import data.AttributeView.AttrViewInstances;
import data.DataType;
import datatools.DataTypeUtils;
import datatools.ExtensibleBytes;
import gltools.sets.ColorSet;
import mesh.Instance2DVertexDataProvider;
import mesh.serialization.data.MeshRecord;
import mesh.VertexAttribProvider;
class NewMeshWriter {
    var sources:Map<String, VertexAttribProvider> = new Map();
    var descriptors:Map<String, AttributeDescr> = new Map();

    public function new() {
    }

    public function addSource(atrName:String, numComponents:Int, type:DataType, prov:VertexAttribProvider) {
        sources.set(atrName, prov);
        descriptors.set(atrName, AttribSet.createAttribute(atrName, numComponents, type));
    }

    public function saveVertsOnly(filename:String, count:Int) {
        var rec:MeshRecord = {
            data:"",
            channels:[]
        }
        var b = new BufferWrapper();
        for (name in descriptors.keys()) {
            var descr = descriptors.get(name);
            var provider = sources.get(name);
            var view = DataTypeUtils.descToView(descr);
            var chCapacity = view.stride * count;
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
            DataTypeUtils.writeVerts(b.buffer.bytes, provider, count, view, b.bufferPosition);
            b.bufferPosition += count * view.stride;
        }
        rec.data = haxe.crypto.Base64.encode(b.buffer.bytes);

        var stream = sys.io.File.write(filename);
        stream.writeString(haxe.Json.stringify(rec, null, " "));
        stream.close();
    }

    public static function deserialize(data:MeshRecord) {
        var bytes = haxe.crypto.Base64.decode(data.data);
        var mesh = new Instance2DVertexDataProvider(ColorSet.instance);
        var vertCount = 0;

        for (ch in data.channels) {
            var accessor = new datatools.BufferView(bytes, ch.view, DataTypeUtils.descToView(ch.desc));
            vertCount = accessor.length;
            mesh.addDataSource(ch.desc.name, accessor.getValue);
        }

        if (data.indices != null) {
            var inds = new datatools.BufferView(bytes, data.indices, AttrViewInstances.IND_VIEW);
            mesh.adIndProvider(inds.getMonoValue);
            mesh.fetchFertices(vertCount, inds.length)
        } else {
            mesh.adIndProvider(n -> n);
            mesh.fetchFertices(vertCount, vertCount);
        }
        return mesh;
    }

//    public function saveVertsAndInds(filename:String, vertCount:Int, indCount:Int) {}

}

class BufferWrapper {
    public var buffer = new ExtensibleBytes(16);
    public var bufCapacity = 0;
    public var bufferPosition = 0;

    public function new() {}
}
