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

    public function initTriangle() {
        addVertex(-0.1, -.1, 0);
        addVertex(.1, -.1, 0);
        addVertex(.1, .1, .1);
        indices = [0, 1, 2];
    }

    var idx = 0;

    public inline function addVertex(x, y, w) {
        state.setValue(AttribAliases.NAME_POSITION, idx, x, 0);
        state.setValue(AttribAliases.NAME_POSITION, idx, y, 1);
        state.setValue(AttribAliases.NAME_SIZE, idx, w, 0);
        addColor();
        idx++;
    }

    inline function addColor() {
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.r, 0);
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.g, 1);
        state.setValue(AttribAliases.NAME_CLOLOR_IN, idx, color.b, 2);
        //        state.setValue(ParallaxGlBg.NAME_CLOLOR_IN, idx, a, 3);
    }
}
