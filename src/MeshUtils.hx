package ;
import data.AttribSet;
import data.AttribSources;
import mesh.I2DCompoundDP.I2DCompoundTypedDP;
class MeshUtils {
    public static function convertToI2DC<T:AttribSet>(set:T, sources:AttribSources<T>, vertCount, indCount):I2DCompoundTypedDP<T> {
        var i2d = new I2DCompoundTypedDP(set);
        for (name in sources.keys()) {
            i2d.addDataSource(name, sources.get(name));
        }
        i2d.fetchVertices(vertCount, indCount);
        return i2d;
    }
}
