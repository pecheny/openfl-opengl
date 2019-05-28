package oglrenderer;
import utils.ExtensibleBytes;
import flash.events.Event;
import lime.graphics.opengl.GLUniformLocation;
import gltools.AttribAliases;
import lime.utils.UInt16Array;
import lime.utils.ArrayBufferView;
import haxe.io.Bytes;
import gltools.AttribSet;
import gltools.ShadersAttrs;
import gltools.VertDataProvider;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;

#if !boo
import lime.graphics.WebGLRenderContext;
#end
class GLLayer<T:AttribSet> extends DisplayObject {
    var program:GLProgram;
    var children:Array<VertDataProvider<T>> = [];
    var gl:WebGLRenderContext;

    var buffer:GLBuffer;
    var set:AttribSet;
    var attrsState:ShadersAttrs;
    var dataView:ArrayBufferView;
    private var indicesBuffer:GLBuffer;



    var screenTIdx:GLUniformLocation;

    @:access(lime.utils.ArrayBufferView)
    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        dataView = new ArrayBufferView(null, None);
    }

    public function init(gl, prog, set:AttribSet) {
        this.program = prog;
        this.set = set;
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
        indicesBuffer = gl.createBuffer();
        trace(prog);


        screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
    }

    function onEnterFrame(e) {
        invalidate();
    }

    public function update() {
        #if !flash
        invalidate();
        #end
    }

    public function addView(v:VertDataProvider<T>) {
        children.push(v) ;
    }

    inline function fetchData() {}

    var data = new ExtensibleBytes(64);


    @:access(lime.utils.ArrayBufferView)
    public function render(event:RenderEvent) {
        trace("rend");
        var renderer:OpenGLRenderer = cast event.renderer;
        gl = renderer.gl;
        if (program == null)
            return;
        var ind = [];
        var pos = 0;
        for (child in children) {
            var b = child.getVerts();
            data.blit(pos, b, 0, b.length);
            pos +=b.length;
            ind = ind.concat(child.getInds());
        }
        trace("Ind: "  + ind);

        bind();
        dataView.initBuffer(data.bytes);
        gl.bufferData(gl.ARRAY_BUFFER, dataView, gl.DYNAMIC_DRAW);
//         set uniforms
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt16Array(ind), gl.DYNAMIC_DRAW);
        gl.drawElements(gl.TRIANGLES, ind.length, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        unbind();
    }


    @:access(lime.utils.ArrayBufferView)
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



