package transform;
import al.core.Boundbox;
import openfl.events.Event;
import datatools.VertValueProvider;
import data.AttribAliases;
import al.al2d.Axis2D;
import al.core.AxisApplier;

//todo make own boundbox, exclude al dependency
class AspectTransform implements VertValueProvider {
    var prv:VertValueProvider;
    var pos:Array<Float> = [0, 0];
    var size:Array<Float> = [1, 1];
    var aspects:StageAspectKeeper;
    var bounds:Boundbox = new Boundbox();
    var appliers:Map<Axis2D, AxisApplier>;
    var bbAspect:Float = 1;
    var localScale = 1.;

    public function new(aspects:StageAspectKeeper, prv) {
        this.aspects = aspects;
        this.prv = prv;
    }

    public function setBounds(x, y, w, h) {
        bounds.set(x, y, w, h);
        bbAspect = w / h;
    }

    public function getValue(v:Int, c:Int):Float {
//        var ls = size[c];
        var a = Axis2D.fromInt(c);
        var free = size[c] - bounds.size[a] * localScale;
        var lp = (prv.getValue(v, c) - bounds.pos[a]) * localScale + free / 2;
        return
            (pos[c] + lp) / aspects.getFactor(c) - 1;
//             pos[c] * aspects.getFactor(c) + prv.getValue(v,c) *  aspects.getFactor(c) * 0.25;
    }

    function refresh() {
        localScale = 9999.;
        for (a in Axis2D.keys) {
            var _scale = size[a.toInt()] / bounds.size[a];
            if (_scale < localScale)
                localScale = _scale;
        }
    }

    public function getAxisApplier(a:Axis2D) {
        if (appliers == null)
            appliers = new Map();
        if (appliers.exists(a))
            return appliers[a];
        var c = switch a {
            case horizontal : 0;
            case vertical : 1;
        }
        var ap = new AspectTransformAxisApplier(this, c);
        appliers[a] = ap;
        return ap ;
    }
}

@:access(transform.AspectTransform)
class AspectTransformAxisApplier implements AxisApplier {
    var axisIntex:Int;
    var target:AspectTransform;

    public function new(target, c) {
        this.target = target;
        axisIntex = c;
    }

    public function applyPos(v:Float):Void {
        target.pos[axisIntex] = v;
    }

    public function applySize(v:Float):Void {
        target.size[axisIntex] = v ;
        target.refresh();
    }
}

class StageAspectKeeper {
    var base:Float;

    var factors:Array<Float> = [1, 1];


    public function new(base = 1) {
        this.base = base;
        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }

    function onResize(e) {
        var stage = openfl.Lib.current.stage;
        var width = stage.stageWidth;
        var height = stage.stageHeight;
        if (width > height) {
            factors[0] = (base * width / height);
            factors[1] = base;
        } else {
            factors[0] = base;
            factors[1] = (base * height / width);
        }
        trace(factors);
    }

    public inline function getFactor(cmp:Int):Float {
        return factors[cmp];
    }

    public function getTransform(attribute:String, a:VertValueProvider):AspectTransform {
        var tr = new AspectTransform(this, a);
        return tr;
    }

}
