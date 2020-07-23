package gltools.aspects;
import bindings.GLUniformLocation;
import bindings.WebGLRenderContext;
import bindings.GLProgram;
import oglrenderer.GLLayer.RenderingElement;
class FloatUniformBinder implements RenderingElement{
    var alias:String;
    var location:GLUniformLocation;
    public var value:Float;
    var gl:WebGLRenderContext;
    public function new(alias, val) {
        this.alias = alias;
        this.value = val;
    }

    public function bind():Void {
        gl.uniform1f(location, value);
    }

    public function unbind():Void {
    }

    public function init(gl:WebGLRenderContext, program:GLProgram):Void {
        this.gl = gl;
        location = gl.getUniformLocation(program, alias);
    }


}
