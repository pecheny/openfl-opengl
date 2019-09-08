package mesh;
import datatools.ByteDataWriter;
import data.DataType;
import data.IndexCollection;
import haxe.io.Bytes;
class VertDataProviderBase {
    var vertData:ByteDataWriter;
    var indData:IndexCollection;
    var vertCount:Int;
    var indCount:Int;


    public function getVerts():Bytes {
        return vertData;
    }

    public function getVertsCount():Int {
        return vertCount;
    }

    public function getInds():IndexCollection {
        return indData;
    }

    public function getIndsCount():Int {
        return indCount;
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
