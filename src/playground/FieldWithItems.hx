package playground;
import gltools.AttribAliases;
import gltools.sets.ColorSet;
import gltools.VertDataProvider;
import haxe.io.Bytes;
import lime.utils.UInt16Array;
import mesh.Instance2DVertexDataProvider;
import mesh.providers.AttrProviders.SolidColorProvider;
import mesh.providers.AttrProviders.TriPosProvider;
import utils.ExtensibleBytes;
class FieldWithItems implements VertDataProvider<ColorSet> {
    var children:Array<Instance2DVertexDataProvider<ColorSet>> = [];
    var vertBlitWrapper:ExtensibleBytes;
    var indBlitWrapper:ExtensibleBytes;
    var attrs:ColorSet;

    var vertPointer = 0;
    var indPointer = 0;


    public function new() {
        attrs = ColorSet.instance;
        vertBlitWrapper = new ExtensibleBytes(5120);
        indBlitWrapper = new ExtensibleBytes(5120);
        var pp = new TriPosProvider(0.1).getPos;
        var cp = new SolidColorProvider(100, 50, 200).getCC;
        var ip = vid -> vid;
        for (i in 0...4) {
            var pp = new TriPosProvider(0.1 + i * 0.1).getPos;
            var cp = new SolidColorProvider(50 + 50 * i, 50, 200).getCC;
            var ch = new Instance2DVertexDataProvider(attrs);
            ch.adIndProvider(ip);
            ch.addDataSource(AttribAliases.NAME_POSITION, pp);
            ch.addDataSource(AttribAliases.NAME_CLOLOR_IN, cp);
            ch.fetchFertices(3, 3);
            children.push(ch);
            ch.x = i * 0.3 - 0.9;
        }

    }

    public function update(dt:Float) {
        for (ch in children)
            ch.y += (Math.random() - 0.5) * dt;
        gatherData();
    }

    inline function gatherData() {
        vertPointer = 0;
        indPointer = 0;


        for (child in children) {
            child.updatePositions();
            var b = child.getVerts();
            var len = child.getVertsCount() * attrs.stride;
            vertBlitWrapper.blit(vertPointer, b, 0, len);
//            trace(vertPointer, b, 0, len);
//            trace(vertBlitWrapper.bytes);
            vertPointer += len;

            var ic = child.getIndsCount();
            indBlitWrapper.blit(indPointer * UInt16Array.BYTES_PER_ELEMENT, child.getInds(), 0, ic * UInt16Array.BYTES_PER_ELEMENT);
            indPointer += ic;
        }
    }

    public function gatherIndices(target:UInt16Array, startWith:Int, offset:Int){
        var idxPointer = startWith;
        var vertPoin = offset;
        for (child in children) {
             child.gatherIndices(target, idxPointer, vertPoin);
            idxPointer += child.getIndsCount();
            vertPoin += child.getVertsCount();
        }
    }
    public function getVerts():Bytes {
        return vertBlitWrapper.bytes;
    }

    public function getVertsCount():Int {
        return vertPointer;
    }

    public function getInds():Bytes {
        return indBlitWrapper.bytes;
    }

    public function getIndsCount():Int {
        return indPointer;
    }


}
