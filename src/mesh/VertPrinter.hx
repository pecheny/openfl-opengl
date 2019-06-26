package mesh;
import haxe.io.UInt16Array;
import gltools.AttribSet;
import gltools.ByteDataReader;
import gltools.VertDataProvider;
class VertPrinter <T:AttribSet> {
    var attrs:T;

    public function new(attrs) {
        this.attrs = attrs;
    }

    public function print(src:VertDataProvider<T>) {
        var reader:ByteDataReader = src.getVerts();
        var result = 'Total vert: ${src.getVertsCount()}, ind:${src.getIndsCount()}\n';
        for (at in attrs.attributes) {
            result += at.name + ": [";
            for (i in 0...src.getVertsCount()) {
                result += "(";
                for (cmp in 0...at.numComponents) {
                    var offset = attrs.stride * i + at.offset + cmp * AttribSet.getGlSize(at.type);
                    result +=
                        AttribSet.getValue(reader, at.type, offset) + ", ";
                }
                result += "), ";
            }
            result += "],\n";
        }
        result += "Inds: ";
        var indReader:ByteDataReader = src.getInds();
        for (i in 0...src.getIndsCount()) {
            result += indReader.getUInt16(i * UInt16Array.BYTES_PER_ELEMENT) + ", ";
        }
        return result;
    }


}
