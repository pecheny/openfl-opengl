package gltools;

import haxe.io.Bytes;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.utils.ArrayBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.DataView;

#if !boo //define used for ide since IDEA got crazy slow on this import. i use lite wersion of WebGLRenderContext for completion purposes only.
import lime.graphics.WebGLRenderContext;
#end

//using lime.utils.ArrayBufferView.ArrayBufferIO;

/**
*  Incapsulates work with different attributes on single buffer.
*  Calculates and stores offset, provides hi-level api to add/set vertex data by attribute and index;
**/

class GlState {
    public var gl:WebGLRenderContext ;
    public var buffer:GLBuffer;
    public var program:GLProgram;
    var data:DataContainer;
    var set:AttribSet;
    var attrsState:ShadersAttrs;

    public function new(gl:WebGLRenderContext, program:GLProgram, set:AttribSet) {
        this.gl = gl;
        this.program = program;
        this.set = set;
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
    }

    public function loadBytes(b:Bytes){
        data = DataContainer.fromBuffer(b);
    }

    public function initData() {
        gl.useProgram(program);
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
    }

    public function getBytes():Bytes {
        return cast (data, ArrayBufferView).buffer;
    }

    public function bind() {
        gl.useProgram(program);
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        set.enableAttributes(gl, attrsState);
    }

    public function unbind() {
        gl.useProgram(null);
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
    }



}
@:forward(setInt8, setFloat32, setInt16, setInt32, setUint8, setUint16, setUint32)
abstract JsDataContainer(DataView) to DataView {
    inline function new(val) this = val;

    public static inline function fromBuffer(buffer:ArrayBuffer) return new JsDataContainer(new DataView(buffer));
}

#if !js
abstract NativeDataContainer(ArrayBufferView) to ArrayBufferView {
    inline function new(val) this = val;

    public function setInt8(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt8(this.buffer, byteOffset, value);

    public function setInt16(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt16(this.buffer, byteOffset, value);

    public function setInt32(byteOffset:Int, value:Int)
    ArrayBufferIO.setInt32(this.buffer, byteOffset, value);

    public function setUint8(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint8(this.buffer, byteOffset, value);

    public function setUint16(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint16(this.buffer, byteOffset, value);

    public function setUint32(byteOffset:Int, value:Int)
    ArrayBufferIO.setUint32(this.buffer, byteOffset, value);

    public function setFloat32(byteOffset:Int, value:Float)
    ArrayBufferIO.setFloat32(this.buffer, byteOffset, value);

    @:access(lime.utils.ArrayBufferView)
    public static inline function fromBuffer(buffer:ArrayBuffer) {
        var buf = new ArrayBufferView(null, None);
        buf.initBuffer(buffer);
        return new NativeDataContainer(buf);
    }
}
#end

typedef DataContainer = #if js JsDataContainer #else NativeDataContainer #end