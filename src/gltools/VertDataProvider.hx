package gltools;
import js.lib.DataView;
import haxe.io.Bytes;
interface VertDataProvider<T:AttribSet> {
    function getVerts():Bytes;
    function getVertsCount():Int;
    function getInds():Bytes;
    function getIndsCount():Int;

/**
*   startFrom - offset within target to write to,
*   offset - lenth of prev vert buffer to add on each vert index
**/
    function gatherIndices(target:VerticesBuffer, startFrom:Int, offset:Int):Void;
}

typedef VerticesBuffer = DataView

//= IndicesTarget;
//
//abstract IndicesTarget(DataView) from DataView to DataView {
//    @arrayAccess public inline function set(key, val) {
//
//    }
//}