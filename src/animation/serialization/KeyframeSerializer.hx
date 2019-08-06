//package animation.serialization;
//import animation.keyframes.Keyframe;
//import data.DataTypeUtils;
//import gltools.AttributeDescr;
//import gltools.ByteDataWriter;
//class KeyframeSerializer {
//    var descr:AttributeDescr;
//
//    public function new() {
//    }
//
//    public function writeFrame(i:Int, k:Keyframe, target:ByteDataWriter, vertCount) {
//        var csize = DataTypeUtils.getGlSize(descr.type)
//        var stride = csize * descr.numComponents;
//        var offset = stride * i;
//        for (v in 0...vertCount)
//            for (c in 0...descr.numComponents)
//                DataTypeUtils.setTyped(target, descr.type, offset + csize * c, k.getValue())
//    }
//}
