package oglrenderer;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
import shader.DummyShader;
import gltools.sets.ColorSet;
import haxe.io.Bytes;
import lime.utils.ArrayBuffer;
import gltools.AttribAliases;
import gltools.AttributeState.DataType;
import gltools.BufferDataWrapper;
import gltools.GLState.GlState;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.math.Matrix4;
import lime.utils.UInt16Array;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import sys.io.File;

class OGLContainer extends DisplayObject {


    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, render);
    }

    public function update() {
        #if !flash
        invalidate();
        #end
    }


    var matrix:Matrix4;
    var program:GLProgram;
    public var state:GlState ;

    private var indicesBuffer:GLBuffer;
    var inited = false;
    var screenTIdx:GLUniformLocation;
    var bufferData2:UInt16Array;
//    var indices = [];


    public function init(gl:WebGLRenderContext) {
        if (!inited) {
            this.program =DummyShader.createDummyShader(gl);

            screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);

            state = new GlState(gl, program, ColorSet.instance);
//            state.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
//            state.addAttribute(AttribAliases.NAME_CLOLOR_IN, 4, DataType.uint8);
//            state.rebuildAttributes();
            state.unbind();

//            state.initDataContainer(3);
            indicesBuffer = gl.createBuffer();
            load();
//            initAndWrite(gl);

            state.initData();
            state.unbind();
            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
            gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, bufferData2, gl.STATIC_DRAW);
            inited = true;
        }
    }

//    function initAndWrite(gl:WebGLRenderContext) {
//        var provider = new BufferDataWrapper(state);
//        provider.initTriangle(1, 1);
//        var b = File.getBytes("bytes");
//        var bytes = state.getBytes();
//        state.loadBytes(b);
//        var stream = File.write("bytes");
//        stream.write(state.getBytes());
//        stream.close();
//
//        var indices = provider.indices;
//        trace(indices);
//        bufferData2 = new UInt16Array(indices);
//        var istream = File.write("ind");
//        istream.write(bufferData2.buffer);
//    }

    function load() {
        var b = File.getBytes("bytes");
        state.loadBytes(b);
        var ind:ArrayBuffer = File.getBytes("ind");
        bufferData2 = new UInt16Array(ind);
        var istream = File.write("ind2");
        istream.write(bufferData2.buffer);
        istream.close();
    }


    public function render(event:RenderEvent) {
        var renderer:OpenGLRenderer = cast event.renderer;
        var gl:WebGLRenderContext = renderer.gl;
        init(renderer.gl);
        if (program == null)
            return;
        state.bind();
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.drawElements(gl.TRIANGLES, 3, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        state.unbind();
    }

}
