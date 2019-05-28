package oglrenderer;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
import gltools.AttribAliases;
import gltools.GLState.GlState;
import gltools.sets.ColorSet;
import gltools.VertexBuilder;
import haxe.io.Bytes;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.math.Matrix4;
import lime.utils.UInt16Array;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import sys.io.File;
#if !boo
import lime.graphics.WebGLRenderContext;
#end
class OGLContainerCopy extends DisplayObject {


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
    private var vertexBuffer:GLBuffer;
    var bufferData2:UInt16Array;

    var inited = false;
    var screenTIdx:GLUniformLocation;

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
    
//    function createProgram(gl:WebGLRenderContext) {
//        var vs = '
//              attribute vec2 ${AttribAliases.NAME_POSITION};
//              uniform float ${AttribAliases.NAME_SCREENSPACE_T};
//
//              void main() {
//                float offset = mod(${AttribAliases.NAME_SCREENSPACE_T} , 1.0);
//                gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x + offset - 0.5, ${AttribAliases.NAME_POSITION}.y,  0, 1);
//              }';
//
//        var fs =
//            #if (!desktop || rpi)
//        "precision mediump float;" +
//            #end
//        '
//              void main(){
//                  gl_FragColor = vec4 (1, 1, 1, 1);
//              }';
//
//        program = GLProgram.fromSources(gl, vs, fs);
//        return program;
//    }
    var indices = [];

    function load(b) {
        state.loadBytes(b);
        bufferData2 = new UInt16Array([0, 1, 2]);
    }

    public function init(gl:WebGLRenderContext) {
        if (!inited) {
            this.program = createProgram(gl);
            state = new GlState(gl, program, ColorSet.instance);
            screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
            var builder = new VertexBuilder(ColorSet.instance);
            builder.setTarget(Bytes.alloc(3 * ColorSet.instance.stride ) );
            var pos = new TriPosProvider(1, -1);
            var color = new SolidColorProvider(128, 10, 100);
            builder.regSetter(AttribAliases.NAME_POSITION, pos.getPos);
            builder.regSetter(AttribAliases.NAME_CLOLOR_IN, color.getCC);
            builder.fetchFertices(3);
            var stream = File.write("bytes2");
            stream.write(builder.getData());
            stream.close();
            load(builder.getData());
//            builder.initDataContainer(6, ColorSet.instance);
//            state.addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
//            state.rebuildAttributes();
//            state.initDataContainer(3);
//            var provider = new BufferDataWrapper(state);
//            provider.color = null;
//            provider.initTriangle(1, -1);

            state.initData();
            state.unbind();
            indicesBuffer = gl.createBuffer();
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

class PosProvider {
    var vertx:Array<Float> = [];
    var verty:Array<Float> = [];

    public function new() {}

    public function addVertex(x, y) {
        vertx.push(x);
        verty.push(y);
    }

}

class SolidColorProvider {
    var components:Array<Float> = [];

    public function new(r, g, b) {
        components.push(r);
        components.push(g);
        components.push(b);
        components.push(255);
    }

    public function getCC(_, cmp) {
        trace(cmp);
        return components[cmp];
    }
}

class TriPosProvider extends PosProvider {

    public function new(scale, mirror = 1) {
        super();
        addVertex(-scale * mirror, -scale);
        addVertex(scale * mirror, -scale);
        addVertex(scale * mirror, scale);
    }

    public function getPos(idx, cmp) {
        var carr =
        if (cmp == 0)
            vertx
        else if (cmp == 1)
            verty
        else throw "Wrong1";
        return carr[idx];
    }
}
