package oglrenderer;
import bindings.WebGLRenderContext;
import flash.events.Event;
import gltools.AttribAliases;
import gltools.AttribSet;
import gltools.ShadersAttrs;
import gltools.VertDataProvider;
import haxe.io.Bytes;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import utils.ExtensibleBytes;

class GLLayer<T:AttribSet> extends DisplayObject {
    var program:GLProgram;
    var children:Array<VertDataProvider<T>> = [];
    var gl:WebGLRenderContext;
    var viewport:ViewportRect;

    var buffer:GLBuffer;
    var set:AttribSet;
    var attrsState:ShadersAttrs;
//    var indDataView:Uint8Array;
    private var indicesBuffer:GLBuffer;
    var screenTIdx:GLUniformLocation;
    var shaderBuilder:WebGLRenderContext->GLProgram;
    
    public function new(set:T, shaderBuilder:WebGLRenderContext->GLProgram) {
        super();
        this.set = set;
        this.shaderBuilder = shaderBuilder;
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    function init(gl) {
        this.program = shaderBuilder(gl);
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
        indicesBuffer = gl.createBuffer();
        screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
//        setIndData(inds.bytes);
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

    var data = new ExtensibleBytes(16);
    var inds = new ExtensibleBytes(64);


    public function render(event:RenderEvent) {
        var renderer:OpenGLRenderer = cast event.renderer;
        gl = renderer.gl;
        if (program == null) {
            init(gl);
        }
        var pos = 0;
        for (child in children) {
            var b:Bytes = child.getVerts();
            var len = child.getVertsCount() * set.stride;
            data.blit(pos, b, 0, len);
            pos += len;
        }
        var indCount = gatherIndices(inds, 0, 0);
        bind();
        if (viewport != null)
            gl.viewport(viewport.x, viewport.y, viewport.width, viewport.height);
//        setVertData(data.bytes);
        gl.bufferData(gl.ARRAY_BUFFER, data.getView(), gl.DYNAMIC_DRAW);
//         set uniforms
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, inds.getView(), gl.DYNAMIC_DRAW);
        gl.drawElements(gl.TRIANGLES, indCount, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        unbind();
    }

    public function gatherIndices(target, startWith:Int, offset:Int) {
        var idxPointer = startWith;
        var vertPoin = offset;
        for (child in children) {
            child.gatherIndices(target, idxPointer, vertPoin);
            idxPointer += child.getIndsCount();
            vertPoin += child.getVertsCount();
        }
        return idxPointer;
    }

    public function setViewport(x, y, w, h) {
        this.viewport = new ViewportRect(x,y,w,h);
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

class ViewportRect {
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;
    public function new (x,y,w,h) {
        this.x = x;
        this.y = y;
        this.width = w;
        this.height = h;
    }
}




