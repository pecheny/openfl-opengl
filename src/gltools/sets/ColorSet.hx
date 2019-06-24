package gltools.sets;
import gltools.AttributeState.DataType;
class ColorSet extends AttribSet{
    public static var instance(default, null):ColorSet = new ColorSet();

    function new() {
        super();
        addAttribute(AttribAliases.NAME_POSITION, 2, DataType.float32);
        addAttribute(AttribAliases.NAME_COLOR_IN, 4, DataType.uint8);
    }
}
