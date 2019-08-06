package data;
import data.DataType;
import gltools.ByteDataWriter;
import lime.utils.Float32Array;
import lime.utils.Int32Array;
import lime.utils.UInt16Array;
import lime.utils.UInt8Array;
import mesh.VertexAttribProvider;
class DataTypeUtils {

    public static inline function getGlSize(type:DataType) {
        return switch type {
            case int32 : Int32Array.BYTES_PER_ELEMENT;
            case uint8 : UInt8Array.BYTES_PER_ELEMENT;
            case uint16 : UInt16Array.BYTES_PER_ELEMENT;
            case float32 : Float32Array.BYTES_PER_ELEMENT;
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
