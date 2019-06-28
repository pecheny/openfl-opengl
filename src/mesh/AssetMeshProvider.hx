package mesh;
import gltools.AttribSet;
import gltools.VertDataProvider;
import haxe.io.Bytes;
import lime.utils.UInt16Array;
using Lambda;
class AssetMeshProvider <T:AttribSet> implements VertDataProvider<T> {
    var data:Bytes;
    var inds:Bytes;
    var stride:Int;

    @:access(lime.utils.AssetLibrary)
    public function new(path:String, attrs:T) {
//        var lib = lime.utils.Assets.getLibrary(null);
//        var ks = lib.paths.keys();
//        trace(lib.paths.array());
//        var bts = lib.getBytes(path + "/bytes");
//        trace(bts  + " " + path);
//        for (k in ks)
//            trace(k  + " " + lib.paths.get(k));

        data = lime.utils.Assets.getBytes(path + "/bytes");//sys.io.File.getBytes(path + "bytes")
        inds = lime.utils.Assets.getBytes(path + "/inds");//sys.io.File.getBytes(path + "bytes")
        stride = attrs.stride;


        var printer = new VertPrinter(attrs);
        trace(printer.print(this));

//        var pp = new PosProvider();
//        var posDescr = ColorSet.instance.getDescr(AttribAliases.NAME_POSITION);
//        var posOfffset = posDescr.offset;
//        pp.load(data, posOfffset, posOfffset + AttribSet.getGlSize(posDescr.type), stride);


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
//        trace("D: " + data  + " " + (data == null));
        var stride1 = Std.int(data.length / stride);
//        trace("Cert cnt:" + stride1);
        return stride1;
    }

    public function getIndsCount():Int {
        var ic = Std.int(inds.length / UInt16Array.BYTES_PER_ELEMENT);
//        trace("Ind cnt: " + ic);
        return ic;
    }


    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
        IndicesFetcher.gatherIndices(target, startFrom, offset, inds, getIndsCount());
    }

//    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
//        for (i in 0...getIndsCount()) {
//            target[i + startFrom] = inds.getUInt16(i*2) + offset;
//        }
//    }


}
