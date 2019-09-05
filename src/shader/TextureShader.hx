package shader;
import Aliases.VA;
import Aliases.UA;
import lime.graphics.opengl.GLProgram;
import data.AttribAliases;
import data.VaryingAliases;
class TextureShader {

    public static function createDummyShader(gl) {
        var vs = '
                 attribute vec2 ${AttribAliases.NAME_POSITION};
                 attribute vec2 ${AttribAliases.NAME_UV_0};
                 varying vec2 ${VaryingAliases.UV_0};

                 void main() {
                   gl_Position =  vec4(${AttribAliases.NAME_POSITION}.x, ${AttribAliases.NAME_POSITION}.y,  0, 1);
                   ${VaryingAliases.UV_0} = ${AttribAliases.NAME_UV_0};
                 }';

        var fs =
            #if (!desktop || rpi)
                "precision mediump float;" +
            #end
                'varying vec2 ${VA.UV_0};
                 uniform sampler2D ${UA.IMG_0};
                 void main(){
				    gl_FragColor = texture2D (${UA.IMG_0}, ${VA.UV_0});
                 }';

        return GLProgram.fromSources(gl, vs, fs);
    }
}
