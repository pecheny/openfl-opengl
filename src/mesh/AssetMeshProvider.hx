package mesh;
import gltools.VertDataProvider;
import lime.utils.UInt16Array;
import gltools.AttribSet;
import haxe.io.Bytes;
class AssetMeshProvider <T:AttribSet> implements VertDataProvider<T>{
    var data:Bytes;
    var inds:Bytes;
    var stride:Int;

    public function new(path:String, attrs:T) {
        data = lime.utils.Assets.getBytes(path + "/bytes");//sys.io.File.getBytes(path + "bytes")
        inds = lime.utils.Assets.getBytes(path + "/inds");//sys.io.File.getBytes(path + "bytes")
        stride = attrs.stride;

//        var builder = new VertexBuilder(ColorSet.instance);
//        builder.setTarget(Bytes.alloc(3 * ColorSet.instance.stride));
//        var pos = new TriPosProvider(1, -1);
//        var color = new SolidColorProvider(128, 10, 100);
//        builder.regSetter(AttribAliases.NAME_POSITION, pos.getPos);
//        builder.regSetter(AttribAliases.NAME_CLOLOR_IN, color.getCC);
//        builder.fetchFertices(3);
//        data = builder.getData();
//        inds = Bytes.alloc(3 * UInt16Array.BYTES_PER_ELEMENT);
//        for (i in 0...3)
//            inds.setUint16(i * UInt16Array.BYTES_PER_ELEMENT, i);
    }

    public function getVerts():Bytes {
        return data;
    }

    public function getInds() {
        return inds;
    }

    public function getVertsCount():Int {
        var stride1 = Std.int(data.length / stride);
        trace("Cert cnt:" + stride1);
        return stride1;
    }

    public function getIndsCount():Int {
        var ic = Std.int(inds.length / UInt16Array.BYTES_PER_ELEMENT);
        trace("Ind cnt: " + ic);
        return ic;
    }
}
