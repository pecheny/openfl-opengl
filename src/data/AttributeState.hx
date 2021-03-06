package data;
import data.DataType;
class AttributeState {
    public var numComponents:Int;
    public var idx:Int;
    public var name:String;
    public var type:DataType; // remove, keep in descr only
    public var offset:Int;

    public function new(idx:Int, numComponents:Int, type:DataType, name:String) {
        this.numComponents = numComponents;
        this.idx = idx;
        this.name = name;
        this.type = type;
    }

}



//abstract DataType2<T>(Int) to Int{
////    int8;
//    inline function new(v) this = v;
//    static public var int16(default, null) = new DataType2<Int>(0);
//    static public var int32(default, null) = new DataType2<Int>(1);
//    static public var uint8 (default, null) = new DataType2<Int>(2);
//    static public var uint16 (default, null) = new DataType2<Int>(3);
//    static public var uint32 (default, null) = new DataType2<Int>(4);
//    static public var float32 (default, null) = new DataType2<Float>(5);
//
//    @:to public function toDatsaType():DataType {
//        if (this == int16)
//            return DataType.int16;
//        if (this == int32)
//            return DataType.int32;
//        if (this == uint16)
//            return DataType.uint16;
//        if (this == uint32)
//            return DataType.uint32;
//        if (this == float32)
//            return DataType.float32;
//        throw "Wrong!";
//    }
//}
