package gltools;
import lime.utils.Int8Array;
import lime.utils.Int16Array;
import lime.utils.Int32Array;
import lime.utils.UInt8Array;
import lime.utils.UInt16Array;
import lime.utils.UInt32Array;
import lime.utils.Float32Array;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class AttributeDescription {
    public var numComponents:Int;
    public var idx:Int;
    public var name:String;
    public var type:DataType;
    public var offset:Int;

    public function new(idx:Int, numComponents:Int, type:DataType, name:String) {
        this.numComponents = numComponents;
        this.idx = idx;
        this.name = name;
        this.type = type;
    }

    public inline function getGlType(gl:WebGLRenderContext) {
        return switch type {
            case int8 : gl.BYTE;
            case int16 : gl.SHORT;
            case int32 : gl.INT;
            case uint8 : gl.UNSIGNED_BYTE;
            case uint16 : gl.UNSIGNED_SHORT;
            case uint32 : gl.UNSIGNED_INT;
            case float32 : gl.FLOAT;
        }
    }


    public inline function getGlSize(gl:WebGLRenderContext) {
        return switch type {
            case int8 : Int8Array.BYTES_PER_ELEMENT;
            case int16 : Int16Array.BYTES_PER_ELEMENT;
            case int32 : Int32Array.BYTES_PER_ELEMENT;
            case uint8 : UInt8Array.BYTES_PER_ELEMENT;
            case uint16 : UInt16Array.BYTES_PER_ELEMENT;
            case uint32 : UInt32Array.BYTES_PER_ELEMENT;
            case float32 : Float32Array.BYTES_PER_ELEMENT;
        }
    }
}

enum DataType {
    int8;
    int16;
    int32;
    uint8;
    uint16;
    uint32;
    float32;
}
