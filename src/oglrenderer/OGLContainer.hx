package oglrenderer;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
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
#if !boo
import lime.graphics.WebGLRenderContext;
#end
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
    var state:GlState ;

    private var indicesBuffer:GLBuffer;
    var inited = false;
    var matrixIdx:Int;
    var screenTIdx:Int;




    function createProgram(gl:WebGLRenderContext) {
        var vs = '
              attribute vec2 ${AttribAliases.NAME_POSITION};
              attribute float ${AttribAliases.NAME_SIZE};
              attribute vec4 ${AttribAliases.NAME_CLOLOR_IN};
              uniform mat4 ${AttribAliases.NAME_MATRIX};
              uniform float ${AttribAliases.NAME_SCREENSPACE_T};
              varying vec4 ${AttribAliases.NAME_CLOLOR_OUT};

              void main() {
                float offset = mod(${AttribAliases.NAME_SCREENSPACE_T} , 1.0) * ${AttribAliases.NAME_SIZE};
                gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x + offset, ${AttribAliases.NAME_POSITION}.y,  0, 1);
                ${AttribAliases.NAME_CLOLOR_OUT} = ${AttribAliases.NAME_CLOLOR_IN};
              }';

        var fs =
            #if (!desktop || rpi)
        "precision mediump float;" +
            #end
        '
              varying vec4 ${AttribAliases.NAME_CLOLOR_OUT};
              void main(){
              gl_FragColor = ${AttribAliases.NAME_CLOLOR_OUT};
              }';

        program = GLProgram.fromSources(gl, vs, fs);
        return program;
    }

    inline function init(gl:WebGLRenderContext) {
        if (!inited) {
            this.program = createProgram(gl);

            matrixIdx = gl.getUniformLocation(program, AttribAliases.NAME_MATRIX);
            screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);

            state = new GlState(gl, program);
            state.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
            state.addAttribute(AttribAliases.NAME_CLOLOR_IN, 3, DataType.uint8);
            state.addAttribute(AttribAliases.NAME_SIZE, 1, DataType.float32);
            state.rebuildAttributes(1000);

            matrix = new Matrix4 ();

            var _width = openfl.Lib.current.stage.stageWidth;
            var _height = openfl.Lib.current.stage.stageHeight;
            var offsetX = -100;//-_width / 6;
            var offsetY = -100;//-_height / 2;

            matrix.createOrtho(offsetX, _width + offsetX, _height + offsetY, offsetY, -1, 1);

            var provider = new BufferDataWrapper(state);
            provider.initTriangle();
            state.initData();

            indicesBuffer = gl.createBuffer();
            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
            var bufferData2 = new UInt16Array(provider.indices);
            gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, bufferData2, gl.STATIC_DRAW);
            gl.useProgram(program);
            inited = true;
        }

    }

    function render(event:RenderEvent) {
        var renderer:OpenGLRenderer = cast event.renderer;
        var gl:WebGLRenderContext = renderer.gl;
        init(renderer.gl);
        if (program == null)
            return;
        state.bind();
        gl.uniformMatrix4fv(matrixIdx, false, matrix);
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        state.unbind();
    }

}
