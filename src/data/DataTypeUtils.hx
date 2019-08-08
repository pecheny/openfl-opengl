package data;
import data.DataType;
import gltools.ByteDataWriter;
import mesh.VertexAttribProvider;
class DataTypeUtils {

    public static inline function getGlSize(type:DataType) {
        return switch type {
            case int32 : 4;
            case uint8 : 1;
            case uint16 : 2;
            case float32 : 4;
        }
    }

    inline public static function setTyped(vertData:ByteDataWriter, type:DataType, offset, value:Dynamic) {
        switch type {
            case int32 : vertData.setInt32(offset, value);
            case uint8 : vertData.setUint8(offset, value);
            case uint16 : vertData.setUint16(offset, value);
            case float32 :
                vertData.setFloat32(offset, value);
        }
    }

    public static function writeVerts(vertData:ByteDataWriter, source:VertexAttribProvider, vertCount:Int, view:AttributeView, startFrom:Int = 0) {
        var cs = getGlSize(view.type);
        for (v in 0...vertCount) {
            for (c in 0...view.numComponents) {
                var offset = startFrom + view.offset + v * view.stride + c * cs;
                DataTypeUtils.setTyped(vertData, view.type, offset, source(v, c));
            }
        }
    }
}
