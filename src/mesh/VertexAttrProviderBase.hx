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
        switch type {
            case int32 : vertData.setInt32(offset, value);
            case uint8 : vertData.setUint8(offset, value);
            case uint16 : vertData.setUint16(offset, value);
            case float32 :
                vertData.setFloat32(offset, value);
        }
    }
}