package oglrenderer;
import bindings.GLUniformLocation;
import bindings.GLBuffer;
import bindings.GLProgram;
import bindings.WebGLRenderContext;
import flash.events.Event;
import data.AttribAliases;
import data.AttribSet;
import data.ShadersAttrs;
import gltools.VertDataProvider;
import haxe.io.Bytes;
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import datatools.ExtensibleBytes;

class GLLayer<T:AttribSet> extends DisplayObject {
    var program:GLProgram;
    var children:Array<VertDataProvider<T>> = [];
    var gl:WebGLRenderContext;
    var viewport:ViewportRect;

    var buffer:GLBuffer;
    var set:AttribSet;
    var attrsState:ShadersAttrs;
    private var indicesBuffer:GLBuffer;
    var screenTIdx:GLUniformLocation;
    var shaderBuilder:WebGLRenderContext->GLProgram;
    var renderingAspect:RenderingElement;
    public function new(set:T, shaderBuilder:WebGLRenderContext->GLProgram, aspect:RenderingElement) {
        super();
        this.renderingAspect = aspect;
        this.set = set;
        this.shaderBuilder = shaderBuilder;
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    function init(gl:WebGLRenderContext) {
        this.program = shaderBuilder(gl);
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
        indicesBuffer = gl.createBuffer();
        screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
        renderingAspect.init(gl, program);
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
        gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
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
        if (renderingAspect!=null)
            renderingAspect.bind();
    }

    public function unbind() {
        gl.useProgram(null);
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
        if (renderingAspect!=null)
            renderingAspect.unbind();
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

interface Bindable {
    function bind():Void;
    function unbind():Void;
}

interface GLInitable {
    public function init(gl:WebGLRenderContext, program:GLProgram):Void;
}

interface RenderingElement extends Bindable extends GLInitable {}




