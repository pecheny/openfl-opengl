package mesh;
import data.IndexCollection;
import gltools.AttribSet;
import gltools.VertDataProvider;
import haxe.io.Bytes;
using Lambda;
class AssetMeshProvider <T:AttribSet> implements VertDataProvider<T> {
    var data:Bytes;
    var inds:IndexCollection;
    var stride:Int;

    public function new(path:String, attrs:T) {
        data = lime.utils.Assets.getBytes(path + "/bytes");
        var haxeBytes:haxe.io.Bytes = lime.utils.Assets.getBytes(path + "/inds");
        inds = haxeBytes;
        stride = attrs.stride;
        var printer = new VertPrinter(attrs);
        trace(printer.print(this));
    }

    public function getVerts():Bytes {
        return data;
    }

    public function getInds() {
        return inds;
    }

    public function getVertsCount():Int {
        var stride1 = Std.int(data.length / stride);
        return stride1;
    }

    public function getIndsCount():Int {
        return inds.length;
    }


    public function gatherIndices(target:VerticesBuffer, startFrom:Int, offset) {
        IndicesFetcher.gatherIndices(target, startFrom, offset, inds, getIndsCount());
    }

}
