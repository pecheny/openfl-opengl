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
                    trace(atr.type);
                    switch atr.type {
//            case int8 : data.setInt8(offset, value);
                        case int16 : data.setInt16(offset, value);
                        case int32 : data.setInt32(offset, value);
                        case uint8 : data.setUint8(offset, value);
                        case uint16 : data.setUint16(offset, value);
                        case uint32 : data.setUint32(offset, value);
                        case float32 : data.setFloat32(offset, value);
                    }
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
