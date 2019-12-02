package gltools;
import data.AttribSet;
import datatools.ExtensibleBytes;
import haxe.io.Bytes;
import haxe.io.UInt16Array;

// todo separate vert and ind interfaces
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

class IndicesFetcher {
    public static inline function gatherIndices(target:VerticesBuffer, startFrom:Int, offset, source:Bytes, count) {
          for (i in 0...count) {
              var uInt = source.getUInt16(i * UInt16Array.BYTES_PER_ELEMENT);
              var pos = (i + startFrom ) * UInt16Array.BYTES_PER_ELEMENT;
              target.grantCapacity(pos + UInt16Array.BYTES_PER_ELEMENT);
              target.bytes.setUInt16(pos, uInt + offset);
          }
      }
}

typedef VerticesBuffer = ExtensibleBytes;

//abstract IndicesTarget(DataView) from DataView to DataView {
//    @:arrayAccess public inline function set(key, val) {
//        this.setUint16(key * UInt16Array.BYTES_PER_ELEMENT, val, true);
//    }
//}