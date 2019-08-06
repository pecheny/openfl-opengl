package animation.keyframes;
interface Keyframe {
    function getValue(vertId:Int, compId:Int):Float;
    function getTime():Float;
    function getVertCount():Int;
}