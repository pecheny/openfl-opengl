package mesh.serialization.data;
import data.serialization.BufferView;
import data.AttributeDescr;
typedef MeshRecord = {
    data:String,
    channels:Array<StaticMeshChannelRecord>,
    ?indices:BufferView
}

typedef StaticMeshChannelRecord = {
    var descr:AttributeDescr;
    var view:BufferView;
}

