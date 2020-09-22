package transform;
import al.al2d.Axis2D;
import al.al2d.Boundbox;
import al.core.AxisApplier;
import datatools.VertValueProvider;

//todo make own boundbox, exclude al dependency
class AspectTransform implements VertValueProvider {
    var prv:VertValueProvider;
    var pos:Array<Float> = [0, 0];
    var size:Array<Float> = [1, 1];
    var aFactors:AspectRatio;
    var bounds:Boundbox = new Boundbox();
    var appliers:Map<Axis2D, AxisApplier>;
    var bbAspect:Float = 1;
    var localScale = 1.;

    public function new(aspects:AspectRatioProvider, prv) {
        aFactors = aspects.getFactorsRef();
        this.prv = prv;
    }

    public function setBounds(x, y, w, h) {
        bounds.set(x, y, w, h);
        bbAspect = w / h;
    }

    public inline function transformValue(c:Int, input:Float) {
        var a = Axis2D.fromInt(c);
        var free = size[c] - bounds.size[a] * localScale;
        var lp = (input - bounds.pos[a]) * localScale + free / 2;
        return
            (pos[c] + lp) / aFactors[c] - 1;
    }

    public function getValue(v:Int, c:Int):Float {
        return transformValue(c, prv.getValue(v, c));
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


//interface AspectFactorsProvider {
//    public function getFactorsRef():ReadOnlyArray<Float>;
//}
//class StageAspectKeeper implements AspectFactorsProvider {
//    var base:Float;
//
//    var factors:Array<Float> = [1, 1];
//
//
//    public function new(base:Float = 1) {
//        this.base = base;
//        openfl.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
//        onResize(null);
//    }
//
//    function onResize(e) {
//        var stage = openfl.Lib.current.stage;
//        var width = stage.stageWidth;
//        var height = stage.stageHeight;
//        if (width > height) {
//            factors[0] = (base * width / height);
//            factors[1] = base;
//        } else {
//            factors[0] = base;
//            factors[1] = (base * height / width);
//        }
////        trace(factors);
//    }
//
//    public inline function getFactor(cmp:Int):Float {
//        return factors[cmp];
//    }
//
//    public function getFactorsRef():ReadOnlyArray<Float> {
//        return factors;
//    }
//
//    public function getTransform(attribute:String, a:VertValueProvider):AspectTransform {
//        var tr = new AspectTransform(this, a);
//        return tr;
//    }
//
//}
