package gltools;
import lime.utils.UInt16Array;
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
    function gatherIndices(target:UInt16Array, startFrom:Int, offset:Int):Void;
}
