package color;
import hxColorToolkit.spaces.HSL;
class ColorMutator {
    var random:RandomProvider;
    var stepLigh = 30;
    var stepHue = 30;
    var stepSaturation = 0;

    public function new(random:RandomProvider = null, stepLight = 30, stepHue = 30, stepSaturation = 0) {
        this.random = random == null ? Math.random : random;
    }

    public function mutate(color:HSL):HSL {
        color.hue += (random() - 0.5) * stepHue;
        color.lightness += (random() - 0.5) * stepLigh;
        color.saturation += (random() - 0.5) * stepSaturation;
        return color;
    }

    public function correlatedMutate(color:HSL):HSL {
        var rnd = random() - 0.5;
        color.hue += rnd * stepHue;
        color.lightness += rnd * stepLigh;
        color.saturation += rnd * stepSaturation;
        return color;
    }
}

typedef RandomProvider = Void -> Float;
typedef ColorProvider = Int -> HSL;
