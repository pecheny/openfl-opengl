package animation;
import animation.keyframes.Keyframe;
import utils.Slactuate;
class AnimationChannel {
    var frames:Array<Keyframe> = [];
    var timestamps:Array<Float> = [];
    var currentTime:Float = 0;
    var currentFrame:Int = 0;
    var paceT:Float = 0;
    var paceDuration:Float = 1;
    public function new() {
    }

    public function addKeyframe(k:Keyframe) {
        if (frames.length > 0) {
            if (frames[frames.length - 1].getTime() > k.getTime())
                throw "Wrong!";
        } else {
            if (k.getTime() != 0)
                throw "First keyframe should be at 0";
        }
        frames.push(k);
        timestamps.push(k.getTime());
    }

    public function setTime(t:Float){
        currentTime = t;
        for (i in 0...timestamps.length)
            if (t < frames[i].getTime()) {
                currentFrame = i - 1;
                paceDuration  = frames[currentFrame + 1].getTime() - frames[currentFrame].getTime();
                paceT = (t - frames[currentFrame].getTime()) / paceDuration;
                return;
            }
        currentFrame = frames.length - 1;
    }

    public function getValue(vertId, compId){
        if (currentFrame > frames.length - 2)
            return frames[currentFrame].getValue(vertId, compId);
        return Slactuate.lerp(paceT, frames[currentFrame].getValue(vertId, compId), frames[currentFrame + 1].getValue(vertId, compId));
    }
}







