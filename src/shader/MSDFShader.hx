package shader;
import text.GPUText.MSDFSet;
import data.AttribAliases;
import bindings.GLProgram;
class MSDFShader {
    public static inline var transform = "transform";
    public static inline var fieldRange = "fieldRange";
    public static inline var resolution = "resolution";
    public static inline var glyphAtlas = "glyphAtlas";
    public static inline var color = "color";
    public static inline var position = AttribAliases.NAME_POSITION;
    public static inline var uv = AttribAliases.NAME_UV_0;
    public static inline var atlasScale = MSDFSet.NAME_ATLAS_SCALE;


    public static function createDummyShader(gl) {
        var vs =
//        '#version 100' +
#if (!desktop || rpi)
        "precision mediump float;" +
#end
        '
					attribute vec2 $position;
					attribute vec3 $uv;
					attribute float $atlasScale;

					uniform mat4 $transform;
					uniform float $fieldRange;
					uniform vec2 $resolution;

					varying vec2 vUv;
					varying float vFieldRangeDisplay_px;

					void main() {
						vUv = $uv.xy;

						// determine the field range in pixels when drawn to the framebuffer
						vec2 scale = abs(vec2(transform[0][0], transform[1][1]));
						vFieldRangeDisplay_px = fieldRange * scale.y * ($resolution.y * 0.5) / $atlasScale;
						vFieldRangeDisplay_px = max(vFieldRangeDisplay_px, 1.0);

						vec2 p = vec2(position.x * resolution.y / resolution.x, position.y);

						gl_Position = transform * vec4(p, 0.0, 1.0);
					}
';

        var fs =
//        '#version 100' +
#if (!desktop || rpi)
        "precision mediump float;" +
#end
        '
					uniform vec4 $color;
					uniform sampler2D $glyphAtlas;
					uniform mat4 $transform;

					varying vec2 vUv;
					varying float vFieldRangeDisplay_px;

					float median(float r, float g, float b) {
					    return max(min(r, g), min(max(r, g), b));
					}

					void main() {
						vec4 sample = texture2D($glyphAtlas, vUv);

						float sigDist = median(sample.r, sample.g, sample.b);

						// spread field range over 1px for antialiasing
						float fillAlpha = clamp((sigDist - 0.5) * vFieldRangeDisplay_px + 0.5, 0.0, 1.0);

						vec4 strokeColor = vec4(0.0, 0.0, 0.0, 1.0);
						float strokeWidthPx = 4.0;
						float strokeDistThreshold = clamp(strokeWidthPx * 2. / vFieldRangeDisplay_px, 0.0, 1.0);
						float strokeDistScale = 1. / (1.0 - strokeDistThreshold);
						float _offset = 0.5 / strokeDistScale;
						float strokeAlpha = clamp((sigDist - _offset) * vFieldRangeDisplay_px + _offset, 0.0, 1.0);

						gl_FragColor = (
							color
							* fillAlpha
							* color.a
							+ strokeColor * strokeColor.a * strokeAlpha * (1.0 - fillAlpha)
						);

						// to help debug stroke
						/**
						gl_FragColor =
							 vec4(vec3(sigDist), 0.) + strokeColor * strokeColor.a * strokeAlpha
							 // * (1.0 - fillAlpha)
						;
						/**/
					}
';

        return GLProgram.fromSources(gl, vs, fs);
    }
}
