package data;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.utils.UInt8Array;
import lime.utils.Int32Array;
import data.DataType;
class DataTypeUtils {

    public static inline function getGlSize(type:DataType) {
        return switch type {
            case int32 : Int32Array.BYTES_PER_ELEMENT;
            case uint8 : UInt8Array.BYTES_PER_ELEMENT;
            case uint16 : UInt16Array.BYTES_PER_ELEMENT;
            case float32 : Float32Array.BYTES_PER_ELEMENT;
        }
    }
}
