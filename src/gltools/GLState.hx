package gltools;

import gltools.AttributeDescription.DataType;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.utils.ArrayBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.DataView;

#if !boo //define used for ide since IDEA got crazy slow on this import. i use lite wersion of WebGLRenderContext for completion purposes only.
import lime.graphics.WebGLRenderContext;
#end

/**
*  Incapsulates work with different attributes on single buffer.
*  Calculates and stores offset, provides hi-level api to add/set vertex data by attribute and index;
**/

class GlState {
    public var gl:WebGLRenderContext ;
    var attributes:Array<AttributeDescription> = [];
    var attribPointers:Map<String, Int> = new Map();
    public var buffer:GLBuffer;
    public var program:GLProgram;
    var stride:Int = 0;
    var data:DataView; // обертка над эррэйбуфер = абстракт над хакси.йо.байтез
    var bufferData:ArrayBufferView;

    public function new(gl:WebGLRenderContext, program:GLProgram) {
        this.gl = gl;
        this.program = program;
        buffer = gl.createBuffer();
    }

    public function addAttribute(name:String, numComponents:Int, type:DataType) {
        var posIdx = gl.getAttribLocation(program, name);
        var descr = new AttributeDescription(posIdx, numComponents, type, name);
        stride += descr.numComponents * descr.getGlSize(gl);
        attribPointers[name] = attributes.length;
        attributes.push(descr);
    }

    public function rebuildAttributes() {
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        enambleAttributes();
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
    }

    public function initDataContainer(vertCount){
        var size = stride * vertCount;
        var buffer = new ArrayBuffer(size);
        data = new DataView(buffer);
    }

    public function enambleAttributes() {
        var offset = 0;
        for (i in 0...attributes.length) {
            var descr = attributes[i];
            descr.offset = offset;
            gl.enableVertexAttribArray(descr.idx);
            var normalized = ("colorIn" == descr.name);
            gl.vertexAttribPointer(descr.idx, descr.numComponents, descr.getGlType(gl), normalized, stride, offset);
            offset += descr.numComponents * descr.getGlSize(gl);
        }
    }

    @:access(lime.utils.ArrayBufferView)
    public function initData() {
        bufferData = new ArrayBufferView(null, None);
        bufferData.initBuffer(data.buffer);
        gl.useProgram(program);
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        gl.bufferData(gl.ARRAY_BUFFER, bufferData, gl.STATIC_DRAW);
    }

    @:access(lime.utils.ArrayBufferView)
    public function bind() {
        gl.useProgram(program);
        gl.depthFunc(gl.ALWAYS);
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
        enambleAttributes();
    }

    public function unbind() {
        gl.useProgram(null);
        gl.depthFunc(gl.LESS);
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
    }

    public function setValue(attribName:String, vertIdx:Int, value:Any, cmpIdx = 0) {
        var descr = attributes[attribPointers[attribName]];
        var offset = stride * vertIdx + descr.offset + cmpIdx * descr.getGlSize(gl);
        switch descr.type {
            case int8 : data.setInt8(offset, value);
            case int16 : data.setInt16(offset, value);
            case int32 : data.setInt32(offset, value);
            case uint8 : data.setUint8(offset, value);
            case uint16 : data.setUint16(offset, value);
            case uint32 : data.setUint32(offset, value);
            case float32 : data.setFloat32(offset, value);
        }
    }


}