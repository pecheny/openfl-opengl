package gltools.sets;
import data.AttribAliases;
import data.AttribSet;
import data.DataType;
class PosSet extends AttribSet {
    public static var instance(default, null):PosSet = new PosSet();

    function new() {
        super();
        addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
    }
}
