package oglrenderer;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
import lime.graphics.opengl.GLUniformLocation;
import gltools.AttribAliases;
import gltools.AttributeDescription.DataType;
import gltools.BufferDataWrapper;
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
class OGLContainerCopy extends DisplayObject {


    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, renderWrapper);
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
    private var vertexBuffer:GLBuffer;
    var bufferData2:UInt16Array;

    var inited = false;
    var screenTIdx:GLUniformLocation;


    function createProgram(gl:WebGLRenderContext) {
        var vs = '
              attribute vec2 ${AttribAliases.NAME_POSITION};
              attribute float ${AttribAliases.NAME_SIZE};
              uniform float ${AttribAliases.NAME_SCREENSPACE_T};

              void main() {
                float offset = mod(${AttribAliases.NAME_SCREENSPACE_T} , 1.0) * ${AttribAliases.NAME_SIZE};
                gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x + offset - 0.5, ${AttribAliases.NAME_POSITION}.y,  0, 1);
              }';

        var fs =
            #if (!desktop || rpi)
              "precision mediump float;" +
            #end
        '
              varying vec4 ${AttribAliases.NAME_CLOLOR_OUT};
              void main(){
              gl_FragColor = vec4 (1, 1, 1, 1);
              }';

        program = GLProgram.fromSources(gl, vs, fs);
        return program;
    }
    var indices = [];

    inline function init(gl:WebGLRenderContext) {
        if (!inited) {
            this.program = createProgram(gl);

            state = new GlState(gl, program);
            screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);

            state.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
            state.addAttribute(AttribAliases.NAME_SIZE, 1, DataType.float32);
            state.rebuildAttributes();
            state.unbind();



            state.initDataContainer(1000);
            var provider = new BufferDataWrapper(state);
            provider.color = null;
            provider.initTriangle(1, -1);
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

//    override function __renderGL(renderer:OpenGLRenderer):Void {
//        render(renderer) ;
//    }

    function renderWrapper(event:RenderEvent) {
        var renderer:OpenGLRenderer = cast event.renderer;
        render(renderer);
    }

    function render(renderer:OpenGLRenderer) {
        var gl:WebGLRenderContext = renderer.gl;
        init(renderer.gl);
        if (program == null)
            return;

        state.bind();
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        state.unbind();
    }

}
