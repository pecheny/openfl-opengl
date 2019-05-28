package gltools;
import haxe.io.Bytes;
interface VertDataProvider<T:AttribSet> {
    function getVerts():Bytes;
    function getVertsCount():Int;
    function getInds():Bytes;
    function getIndsCount():Int;

}
