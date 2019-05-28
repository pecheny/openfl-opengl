package mesh;
import gltools.AttribAliases;
import gltools.AttribSet;
import gltools.ByteDataWriter;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;
import gltools.VertexBuilder;
import haxe.io.Bytes;
import oglrenderer.OGLContainerCopy.SolidColorProvider;
import oglrenderer.OGLContainerCopy.TriPosProvider;
class StaticMeshProvider<T:AttribSet> implements VertDataProvider<T> {
    var data:ByteDataWriter;
    var inds = [0,1,2];

    public function new() {
        var builder = new VertexBuilder(ColorSet.instance);
        builder.setTarget(Bytes.alloc(3 * ColorSet.instance.stride));
        var pos = new TriPosProvider(1, -1);
        var color = new SolidColorProvider(128, 10, 100);
        builder.regSetter(AttribAliases.NAME_POSITION, pos.getPos);
        builder.regSetter(AttribAliases.NAME_CLOLOR_IN, color.getCC);
        builder.fetchFertices(3);
        data = builder.getData();
    }

    public function getVerts():Bytes {
        return data;
    }

    public function getInds():Array<Int> {
        return inds;
    }


}
