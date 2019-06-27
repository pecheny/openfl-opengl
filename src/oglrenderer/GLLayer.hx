package oglrenderer;
import js.html.Uint8Array;
import js.lib.Float32Array;
import js.lib.Uint16Array;
import js.lib.DataView;
import haxe.io.Bytes;
import lime.math.Rectangle;
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
    var viewport:ViewportRect;

    var buffer:GLBuffer;
    var set:AttribSet;
    var attrsState:ShadersAttrs;
    var dataView:Uint8Array;
    var indDataView:Uint8Array;
    private var indicesBuffer:GLBuffer;
    var screenTIdx:GLUniformLocation;
    var shaderBuilder:WebGLRenderContext->GLProgram;
    
    @:access(lime.utils.ArrayBufferView)
    public function new(set:T, shaderBuilder:WebGLRenderContext->GLProgram) {
        super();
        this.set = set;
        this.shaderBuilder = shaderBuilder;
        addEventListener(RenderEvent.RENDER_OPENGL, render);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        #if !js
        dataView = new ArrayBufferView(null, None);
        indDataView = new ArrayBufferView(null, None);
        #end
    }

    @:access(lime.utils.ArrayBufferView)
    function init(gl) {
        this.program = shaderBuilder(gl);
        attrsState = set.buildState(gl, program);
        buffer = gl.createBuffer();
        indicesBuffer = gl.createBuffer();
        screenTIdx = gl.getUniformLocation(program, AttribAliases.NAME_SCREENSPACE_T);
        setIndData(inds.bytes);
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
        if (program == null) {
            init(gl);
        }
        var pos = 0;
        for (child in children) {
            var b:Bytes = child.getVerts();

            var len = child.getVertsCount() * set.stride;
            var r = "ch: " + len  + " " ;
            data.blit(pos, b, 0, len);
           for (i in 0...6) {
                r += data.bytes.getFloat(i*Float32Array.BYTES_PER_ELEMENT) + ", ";
            }
            trace(r);
            pos += len;
        }
        var indCount = gatherIndices(indDataView, 0, 0);
        bind();
        if (viewport != null)
            gl.viewport(viewport.x, viewport.y, viewport.width, viewport.height);
        setVertData(data.bytes);
        gl.bufferData(gl.ARRAY_BUFFER, dataView, gl.DYNAMIC_DRAW);
//         set uniforms
        gl.uniform1f(screenTIdx, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indDataView, gl.DYNAMIC_DRAW);
        gl.drawElements(gl.TRIANGLES, indCount, gl.UNSIGNED_SHORT, 0);
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
        unbind();
    }

    public function gatherIndices(target, startWith:Int, offset:Int) {
        var view = new DataView(target.buffer);
        var idxPointer = startWith;
        var vertPoin = offset;
        for (child in children) {
             child.gatherIndices(view, idxPointer, vertPoin);
            idxPointer += child.getIndsCount();
            vertPoin += child.getVertsCount();
        }
        return idxPointer;
    }

    public function setViewport(x, y, w, h) {
        this.viewport = new ViewportRect(x,y,w,h);
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

    @:access(haxe.io.Bytes)
    function setIndData(b:Bytes) {
        #if js
//            indDataView = cast b.b;
            indDataView = new js.lib.Uint8Array(b.getData());
//            trace(haxe.io.BytesData.isView(indDataView ));
//            printU16(indDataView);
        #else
            indDataView.initBuffer(b);
        #end
    }

    @:access(haxe.io.Bytes)
     function setVertData(b:Bytes) {
        #if js

            dataView = new js.lib.Uint8Array(b.getData());
//            dataView.setFloat32(0, 0.5);
//            trace("data: "  + " " + b.get(0)  + " " +  dataView.getUint8(0));
//        trace("data: "  + " " + b.getFloat(0)  + " " +  dataView.getFloat32(0, true));
//            dataView = b.b;
        #else
            dataView.initBuffer(b);
        #end
    }

    function printF32(dv:DataView) {
           var r = "";
           for (i in 0...Std.int(dv.byteLength / Float32Array.BYTES_PER_ELEMENT)) {
               r += dv.getUint16(i*Float32Array.BYTES_PER_ELEMENT) + ", ";
           }
           trace(r);
       }

    function printU16(dv:DataView) {
        var r = "";
        for (i in 0...Std.int(dv.byteLength / UInt16Array.BYTES_PER_ELEMENT)) {
            r += dv.getUint16(i*Uint16Array.BYTES_PER_ELEMENT) + ", ";
        }
        trace(r);
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




