package mesh;
import datatools.ByteDataWriter;
import data.AttribAliases;
import gltools.sets.ColorSet;
import gltools.VertexBuilder;
import haxe.io.Bytes;
import haxe.io.UInt16Array;
import mesh.providers.AttrProviders.SolidColorProvider;
class MeshWriter {
    var data:ByteDataWriter;
    var inds:ByteDataWriter;
    var builder:VertexBuilder;
    var indProvider:Int->Int;
    public function new() {
        builder = new VertexBuilder(ColorSet.instance);
        var color = new SolidColorProvider(128, 10, 100);
        builder.regSetter(AttribAliases.NAME_COLOR_IN, color.getCC);
    }


    public function addPosProvider(posProv:VertexAttribProvider){
        builder.regSetter(AttribAliases.NAME_POSITION, posProv);
    }

    public function adIndProvider(p:Int->Int){
        indProvider = p;
    }

    public function addCustomProvider(name, prov){
        builder.regSetter(name, prov);
    }

    public function fetch(vertCount:Int, triCount:Int) {
        trace("! " +  vertCount  + " " + ColorSet.instance.stride);
        builder.setTarget(Bytes.alloc(vertCount * ColorSet.instance.stride));
        builder.fetchFertices(vertCount);
        data = builder.getData();
        inds = Bytes.alloc(3 * triCount * UInt16Array.BYTES_PER_ELEMENT);
        for (i in 0...triCount * 3)
            inds.setUint16(i * UInt16Array.BYTES_PER_ELEMENT, indProvider(i));
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
