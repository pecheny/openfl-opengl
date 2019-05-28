package mesh;
import haxe.io.UInt16Array;
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
    var inds:ByteDataWriter;

    public function new() {
        var builder = new VertexBuilder(ColorSet.instance);
        builder.setTarget(Bytes.alloc(3 * ColorSet.instance.stride));
        var pos = new TriPosProvider(1, -1);
        var color = new SolidColorProvider(128, 10, 100);
        builder.regSetter(AttribAliases.NAME_POSITION, pos.getPos);
        builder.regSetter(AttribAliases.NAME_CLOLOR_IN, color.getCC);
        builder.fetchFertices(3);
        data = builder.getData();
        inds = Bytes.alloc(3 * UInt16Array.BYTES_PER_ELEMENT);
        for (i in 0...3)
            inds.setUint16(i * UInt16Array.BYTES_PER_ELEMENT, i);
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
