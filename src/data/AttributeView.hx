package data;
// todo merge with AttrDesc
typedef AttributeView = {
    var stride:Int;
    var offset:Int;
    var numComponents:Int;
    var type:DataType;
}

class AttrViewInstances {
    public static inline var IND_VIEW:AttributeView = {
        stride:IndexCollection.ELEMENT_SIZE,
        offset:0,
        numComponents:1,
        type:DataType.uint16
    }
}
