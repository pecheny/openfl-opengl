package shader;
import data.AttribAliases;
import lime.graphics.opengl.GLProgram;
class DummyShader {
    public function new() {
    }

    public static function createDummyShader(gl) {
     var vs = '
                 attribute vec2 ${AttribAliases.NAME_POSITION};
                 attribute vec4 ${AttribAliases.NAME_COLOR_IN};
                 uniform float ${AttribAliases.NAME_SCREENSPACE_T};
                 varying vec4 ${AttribAliases.NAME_COLOR_OUT};

                 void main() {
                   float offset = mod(${AttribAliases.NAME_SCREENSPACE_T} , 1.0);
                   gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x + offset, ${AttribAliases.NAME_POSITION}.y,  0., 1.);
                   ${AttribAliases.NAME_COLOR_OUT} = ${AttribAliases.NAME_COLOR_IN};
                 }';

           var fs =
               #if (!desktop || rpi)
           "precision mediump float;" +
               #end
           'varying vec4 ${AttribAliases.NAME_COLOR_OUT};
                 void main(){
                    gl_FragColor = ${AttribAliases.NAME_COLOR_OUT};
                 }';

           return GLProgram.fromSources(gl, vs, fs);
    }
}
