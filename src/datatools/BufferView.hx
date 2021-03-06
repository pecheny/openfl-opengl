package datatools;
import data.AttribSet;
import data.AttributeView;
import data.serialization.BufferView as BufferViewRec;
class BufferView<T:Float> implements VertValueProvider {
    var bytes:haxe.io.Bytes;
    var view:BufferViewRec;
    var attrView:AttributeView;
    public var length(get, never):Int;
    public function new(bytes, view:BufferViewRec, attrView:AttributeView) {
        this.bytes = bytes;
        this.view = view;
        this.attrView = attrView;
    }

    public function getValue(vertId, cmpId):T {
        var offset = view.byteOffset + attrView.stride * vertId + attrView.offset + cmpId * AttribSet.getGlSize(attrView.type);
        return cast AttribSet.getValue(bytes, attrView.type, offset);
    }

    public function getMonoValue(vertId):T {
        var offset = view.byteOffset + attrView.stride * vertId + attrView.offset;
        return cast AttribSet.getValue(bytes, attrView.type, offset);
    }

    function get_length():Int {
        return Std.int(view.byteLength / attrView.stride);
    }

    public static function wholeBytesOf(b:haxe.io.Bytes):BufferViewRec {
        return {
            byteLength:b.length,
            byteOffset:0
        }
    }

}
