package animation.keyframes;
import mesh.VertexAttribProvider;
class ProviderKeyframe implements Keyframe {
    var provider:VertexAttribProvider;
    var time:Float;

    public function new(t, p){
        this.time = t;
        this.provider = p;
    }

    public function getTime():Float{
        return time;
    }

    public function getValue(vertId, compId):Float{
        return provider(vertId, compId);
    }
}