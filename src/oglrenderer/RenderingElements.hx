package oglrenderer;
import bindings.GLProgram;
import bindings.WebGLRenderContext;
import oglrenderer.GLLayer.RenderingElement;
class RenderingElements implements RenderingElement {
    var children:Array<RenderingElement>;

    public function new(children) {
        this.children = children;
    }

    public function bind():Void {
        for (c in children)
            c.bind();
    }

    public function unbind():Void {
        for (c in children)
            c.unbind();
    }

    public function init(gl:WebGLRenderContext, program:GLProgram):Void {
        for (c in children)
            c.init(gl, program);
    }

}
