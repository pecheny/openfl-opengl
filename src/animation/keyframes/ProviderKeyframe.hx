package animation.keyframes;
import mesh.VertexAttribProvider;
class ProviderKeyframe implements Keyframe {
    var provider:VertexAttribProvider;
    var time:Float;
    var vertCount:Int;

    public function new(t, p, vc){
        this.time = t;
        this.provider = p;
        this.vertCount = vc;
    }

    public function getTime():Float{
        return time;
    }

    public function getValue(vertId, compId):Float{
        return provider(vertId, compId);
    }


    public function getVertCount():Int {
        return vertCount;
    }
}