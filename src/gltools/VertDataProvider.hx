package gltools;
import haxe.io.Bytes;
interface VertDataProvider<T:AttribSet> {
    function getVerts():Bytes;
    function getInds():Array<Int>;
}
