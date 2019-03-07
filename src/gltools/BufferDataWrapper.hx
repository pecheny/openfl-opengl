package gltools;
import gltools.GLState.GlState;
import utils.Color;
class BufferDataWrapper {
    public var indices = [];
    var state:GlState;
    public var color = new Color(128, 0, 200);

    public function new(state:GlState) {
        this.state = state;
    }

    public function initTriangle(scale, mirror) {
        addVertex(-scale*mirror, -scale, 0);
        addVertex(scale*mirror, -scale, 0);
        addVertex(scale*mirror,scale ,scale );
        indices = [0, 1, 2];
    }

    var idx = 0;

    public inline function addVertex(x, y, w) {
        state.setValue(AttribAliases.NAME_POSITION, idx, x, 0);
        state.setValue(AttribAliases.NAME_POSITION, idx, y, 1);
//        state.setValue(AttribAliases.NAME_SIZE, idx, w, 0);
        if (color != null)
            addColor();
        idx++;
    }

    inline function addColor() {
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.r, 0);
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.g, 1);
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.b, 2);
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, 255, 3);
//        state.setValue(ParallaxGlBg.NAME_CLOLOR_IN, idx, a, 3);
    }
}
