package ;
import data.AttribSet;
import data.AttribSources;
import mesh.I2DCompoundDP.I2DCompoundTypedDP;
import data.AttributeDescr;
import data.DataType;
import data.VertexAttribProvider;
class MeshUtils {
    public static function convertToI2DC<T:AttribSet>(set:T, sources:AttribSources<T>, vertCount, indCount):I2DCompoundTypedDP<T> {
        var i2d = new I2DCompoundTypedDP(set);
        for (name in sources.keys()) {
            i2d.addDataSource(name, sources.get(name));
        }
        i2d.fetchVertices(vertCount, indCount);
        return i2d;
    }

    public static function writeInt8Attribute<T:AttribSet>(attrs:AttribSet, bytes:haxe.io.Bytes, attName:String, firstVert:Int, vertCount:Int, provider:VertexAttribProvider) {
        var descr:AttributeDescr = attrs.getDescr(attName);
        if (descr.type != DataType.uint8)
            throw "wrong type";
        var size = AttribSet.getGlSize(descr.type);
        for (v in 0...vertCount) {
            for (c in 0...descr.numComponents) {
                var pos =
                attrs.stride * (firstVert + v)
                + descr.offset
                + c * size;
                bytes.set(pos, provider(v, c));
            }
        }
    }

    public static function writeFloatAttribute<T:AttribSet>(attrs:AttribSet, bytes:haxe.io.Bytes, attName:String, firstVert:Int, vertCount:Int, provider:VertexAttribProvider) {
        var descr:AttributeDescr = attrs.getDescr(attName);
        if (descr.type != DataType.float32)
            throw "wrong type";
        var size = AttribSet.getGlSize(descr.type);
        for (v in 0...vertCount) {
            for (c in 0...descr.numComponents) {
                var pos =
                attrs.stride * (firstVert + v)
                + descr.offset
                + c * size;
                bytes.setFloat(pos, provider(v, c));
            }
        }
    }

}
