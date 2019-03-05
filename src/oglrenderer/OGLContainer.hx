package oglrenderer;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
import lime.graphics.opengl.GLUniformLocation;
import gltools.BufferDataWrapper;
import gltools.AttribAliases;
import gltools.AttributeDescription.DataType;
import gltools.GLState.GlState;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix4;
import lime.utils.UInt16Array;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;

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
    var indices = [];


    function createProgram(gl:WebGLRenderContext) {
        var vs = '
              attribute vec2 ${AttribAliases.NAME_POSITION};
              attribute vec4 ${AttribAliases.NAME_CLOLOR_IN};
              uniform float ${AttribAliases.NAME_SCREENSPACE_T};
              varying vec4 ${AttribAliases.NAME_CLOLOR_OUT};

              void main() {
                float offset = mod(${AttribAliases.NAME_SCREENSPACE_T} , 1.0);
                gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x + offset, ${AttribAliases.NAME_POSITION}.y,  0, 1);
                ${AttribAliases.NAME_CLOLOR_OUT} = ${AttribAliases.NAME_CLOLOR_IN};
              }';

        var fs =
            #if (!desktop || rpi)
            "precision mediump float;" +
            #end
              'varying vec4 ${AttribAliases.NAME_CLOLOR_OUT};
              void main(){
                 gl_FragColor = ${AttribAliases.NAME_CLOLOR_OUT};
              }';

        program = GLProgram.fromSources(gl, vs, fs);
        return program;
    }


    public function init(gl:WebGLRenderContext) {
        if (!inited) {
            this.program = createProgram(gl);

            screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);

            state = new GlState(gl, program);
            state.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
            state.addAttribute(AttribAliases.NAME_CLOLOR_IN, 3, DataType.uint8);
            state.rebuildAttributes();
            state.unbind();

            state.initDataContainer(3);
            var provider = new BufferDataWrapper(state);
            provider.initTriangle(1, 1);
            state.initData();
            state.unbind();
            indices = provider.indices;
            indicesBuffer = gl.createBuffer();
            bufferData2 = new UInt16Array(indices);
            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
            gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, bufferData2, gl.STATIC_DRAW);
            inited = true;
        }

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
