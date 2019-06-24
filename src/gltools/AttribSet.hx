package gltools;
#if (cpp || js)
import lime.graphics.opengl.GLProgram;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
#end
import lime.utils.Int16Array;
import haxe.io.Int32Array;
import haxe.io.UInt8Array;
import haxe.io.UInt16Array;
import haxe.io.UInt32Array;
import haxe.io.Float32Array;
import gltools.AttributeState.DataType;
class AttribSet {
    function new() {}
    public var stride(default, null):Int = 0;
    public var attributes:Array<AttributeDescr> = [];
//    var offset:Int = 0;

    function addAttribute(name:String, numComponents:Int, type:DataType) {
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

    public static inline function getGlSize(type) {
        return switch type {
//            case int8 : Int8Array.BYTES_PER_ELEMENT;
            case int16 : Int16Array.BYTES_PER_ELEMENT;
            case int32 : Int32Array.BYTES_PER_ELEMENT;
            case uint8 : UInt8Array.BYTES_PER_ELEMENT;
            case uint16 : UInt16Array.BYTES_PER_ELEMENT;
            case uint32 : UInt32Array.BYTES_PER_ELEMENT;
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
            offset += descr.numComponents * descr.getGlSize();
        }
    }

    public inline function getGlType(type, gl:WebGLRenderContext) {
        return switch type {
//            case int8 : gl.BYTE;
            case int16 : gl.SHORT;
            case int32 : gl.INT;
            case uint8 : gl.UNSIGNED_BYTE;
            case uint16 : gl.UNSIGNED_SHORT;
            case uint32 : gl.UNSIGNED_INT;
            case float32 : gl.FLOAT;
        }
    }
    #end
}
