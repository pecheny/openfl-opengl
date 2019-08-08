package gltools;
import bindings.WebGLRenderContext;
import data.DataType;
#if (cpp || js)
import data.DataTypeUtils;
import lime.graphics.opengl.GLProgram;
#end
import haxe.io.Float32Array;
import haxe.io.Int32Array;
import haxe.io.UInt16Array;
import haxe.io.UInt8Array;
class AttribSet {
    public function new() {}
    public var stride(default, null):Int = 0;
    public var attributes:Array<AttributeDescr> = [];
//    var offset:Int = 0;

   public function addAttribute(name:String, numComponents:Int, type:DataType) {
        var descr = {
            name:name,
            numComponents:numComponents,
            type:type,
            offset:stride
        }
        stride += numComponents * getGlSize(type);
//        attribPointers[name] = attributes.length;
        attributes.push(descr);
    }

    public function getDescr(name):AttributeDescr {
        for (d in attributes) {
            if (d.name == name)
                return d;
        }
        throw "No such attr " + name;
    }

    public static inline function getValue(reader:ByteDataReader, type:DataType, offset) {
        return
            switch type {
                case uint8 : reader.getUInt8(offset);
                case int32 : reader.getInt32(offset);
                case uint16 : reader.getUInt16(offset);
                case float32 : reader.getFloat32(offset);
            }
    }

    public static inline function setValue(reader:ByteDataWriter, type:DataType, offset:Int, val:Dynamic) {
        return
            switch type {
                case uint8 : reader.setUint8(offset, val);
                case int32 : reader.setInt32(offset, val);
                case uint16 : reader.setUint16(offset, val);
                case float32 : reader.setFloat32(offset, val);
            }
    }

    public static inline function getGlSize(type:DataType) {
        return switch type {
            case int32 : Int32Array.BYTES_PER_ELEMENT;
            case uint8 : UInt8Array.BYTES_PER_ELEMENT;
            case uint16 : UInt16Array.BYTES_PER_ELEMENT;
            case float32 : Float32Array.BYTES_PER_ELEMENT;
        }
    }

//    public function addAttribute2(name:String, numComponents:Int, type:DataType) {
////        stride += descr.numComponents * descr.getGlSize(gl);
////        attribPointers[name] = attributes.length;
//        attributes.push(descr);
//    }

    #if (cpp || js)

    public function buildState(gl:WebGLRenderContext, program:GLProgram) {
        var attrs = [];
        for (desc in attributes) {
            var posIdx = gl.getAttribLocation(program, desc.name);
            attrs.push(new AttributeState(posIdx, desc.numComponents, desc.type, desc.name));
        }
        return new ShadersAttrs(attrs);
    }

    public function enableAttributes(gl:WebGLRenderContext, attrsState:ShadersAttrs) {
        var offset = 0;
        var attributes = attrsState.attrs;
        for (i in 0...attributes.length) {
            var descr:AttributeState = attributes[i];
            descr.offset = offset;
            gl.enableVertexAttribArray(descr.idx);
            var normalized = ("colorIn" == descr.name);
            gl.vertexAttribPointer(descr.idx, descr.numComponents, getGlType(descr.type, gl), normalized, stride, offset);
            offset += descr.numComponents * DataTypeUtils.getGlSize(descr.type);
        }
    }

    public inline function getGlType(type:DataType, gl:WebGLRenderContext) {
        return switch type {
            case int32 : gl.INT;
            case uint8 : gl.UNSIGNED_BYTE;
            case uint16 : gl.UNSIGNED_SHORT;
            case float32 : gl.FLOAT;
        }
    }
    #end
}
