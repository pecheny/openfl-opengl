package gltools;
import mesh.VertexAttribProvider;
import haxe.io.Bytes;
class VertexBuilder {
    var data:ByteDataWriter;
    var a:AttribSet;

    public function new(a:AttribSet) {
        this.a = a;
    }

    public function setTarget(data:Bytes) {
        this.data = data;
        return this;
    }

    public function getData():Bytes return data;

    public function fetchFertices(vertCount:Int) {
        for (i in 0...vertCount) {
            for (atr in a.attributes) {
                trace(atr.name);
                for (cmp in 0...atr.numComponents) {
                    var value = setters.get(atr.name)(i, cmp);
                    var offset = a.stride * i + atr.offset + cmp * AttribSet.getGlSize(atr.type);
                    AttribSet.setValue(data, atr.type, offset, value);
                    trace(atr.type);
                }
            }
        }
        trace("done");
    }

//    function setValue(idx, name) {}

    var setters:Map<String, VertexAttribProvider> = new Map();

    public function regSetter(attrDesc:String, setter:VertexAttribProvider) {
        setters.set(attrDesc,  setter);
    }

}

interface ValueProvider<T> {
    function getValue(vertIdx:Int):T;
}
