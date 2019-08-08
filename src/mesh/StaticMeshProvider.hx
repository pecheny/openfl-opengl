package mesh;
import data.IndexCollection;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import gltools.AttribAliases;
import gltools.AttribSet;
import gltools.ByteDataWriter;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;
import gltools.VertexBuilder;
import haxe.io.Bytes;
import haxe.io.UInt16Array;
class StaticMeshProvider<T:AttribSet> implements VertDataProvider<T> {
    var data:ByteDataWriter;
    var inds:ByteDataWriter;

    public function new() {
        var builder = new VertexBuilder(ColorSet.instance);
        builder.setTarget(Bytes.alloc(3 * ColorSet.instance.stride));
        var pos = new TriPosProvider(1, -1);
        var color = new SolidColorProvider(128, 10, 100);
        builder.regSetter(AttribAliases.NAME_POSITION, pos.getPos);
        builder.regSetter(AttribAliases.NAME_COLOR_IN, color.getCC);
        builder.fetchFertices(3);
        data = builder.getData();
        inds = new IndexCollection(3);
        for (i in 0...3)
            inds[i] = i;
    }

    public function getVerts():Bytes {
        return data;
    }

    public function getInds() {
        return inds;
    }

    public function getVertsCount():Int {
        return 3;
    }

    public function getIndsCount():Int {
        return 3;
    }


}
