package mesh;
import data.DataType;
import haxe.io.Bytes;
import datatools.ByteDataWriter;
class VertexAttrProviderBase {
    var vertData:ByteDataWriter;
    var vertCount:Int;

    public function getVerts():Bytes {
        return vertData;
    }

    public function getVertsCount():Int {
        return vertCount;
    }

    inline function setTyped(type:DataType, offset, value:Dynamic) {
        vertData.setTyped(type, offset, value);
    }
}