package gltools;
import data.AttribSet;
import datatools.ExtensibleBytes;
import gltools.VertDataTarget.RenderDataTarget;
import haxe.io.Bytes;

// todo separate vert and ind interfaces
interface IndexProvider {
    function getInds():Bytes;

    function getIndsCount():Int;

}
interface VertDataProvider<T:AttribSet> {
    function getVertsCount():Int;

    function render(target:RenderDataTarget):Void;
}
interface VertIndDataProvider<T:AttribSet> extends IndexProvider extends VertDataProvider<T> {
}



//typedef VerticesBuffer = ExtensibleBytes;

//abstract IndicesTarget(DataView) from DataView to DataView {
//    @:arrayAccess public inline function set(key, val) {
//        this.setUint16(key * UInt16Array.BYTES_PER_ELEMENT, val, true);
//    }
//}


