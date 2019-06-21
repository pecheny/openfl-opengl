package oglrenderer;
import utils.ExtensibleBytes;
import flash.events.Event;
import lime.graphics.opengl.GLUniformLocation;
import gltools.AttribAliases;
import lime.utils.UInt16Array;
import lime.utils.ArrayBufferView;
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
    var indDataView:UInt16Array;
    private var indicesBuffer:GLBuffer;
    var screenTIdx:GLUniformLocation;

    @:access(lime.utils.ArrayBufferView)
    public function new() {
        super();
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        dataView = new ArrayBufferView(null, None);
        indDataView = new ArrayBufferView(null, None);
    }

    @:access(lime.utils.ArrayBufferView)
    public function init(gl, prog, set:AttribSet) {
        this.program = prog;
        this.set = set;
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
        indicesBuffer = gl.createBuffer();
        trace(prog);
        screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
        indDataView.initBuffer(inds.bytes);
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
    var inds = new ExtensibleBytes(64);


    @:access(lime.utils.ArrayBufferView)
    public function render(event:RenderEvent) {
        var renderer:OpenGLRenderer = cast event.renderer;
        gl = renderer.gl;
        if (program == null)
            return;
        var pos = 0;
//        trace("______________" + set.stride);
        for (child in children) {
            var b = child.getVerts();
            var len = child.getVertsCount() * set.stride;
            data.blit(pos, b, 0, len);
            pos += len;
//            var ic += child.getIndsCount();
////            inds.blit(indCount * UInt16Array.BYTES_PER_ELEMENT, child.getInds(), 0, ic * UInt16Array.BYTES_PER_ELEMENT);
////            for (vid in indCount...indCount+ic) {
////                indDataView[vid] += indCount;
////            }
//            indCount += ic;
//            trace(ic);
//            ind = ind.concat(child.getInds());
        }
        var indCount = gatherIndices(indDataView, 0, 0);
        bind();
        dataView.initBuffer(data.bytes);
        gl.bufferData(gl.ARRAY_BUFFER, dataView, gl.DYNAMIC_DRAW);
//         set uniforms
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indDataView, gl.DYNAMIC_DRAW);
        gl.drawElements(gl.TRIANGLES, indCount, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        unbind();
    }

    public function gatherIndices(target:UInt16Array, startWith:Int, offset:Int) {
        var idxPointer = startWith;
        var vertPoin = offset;
        for (child in children) {
             child.gatherIndices(target, idxPointer, vertPoin);
            idxPointer += child.getIndsCount();
            vertPoin += child.getVertsCount();
        }
        return idxPointer;
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



