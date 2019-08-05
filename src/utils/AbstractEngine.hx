package utils;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
class AbstractEngine extends Sprite {
    var last:Int;
    var timeMultiplier:Float = 1;
    inline static var maxElapsed = 0.016666666;

    public function new() {
        super();
        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function enterFrameHandler(e:Event):Void {
        var time = Lib.getTimer();
        var elapsed = (time - last) / 1000;
        if (elapsed > maxElapsed) elapsed = maxElapsed;
        last = time;
//        update(maxElapsed);
        update(elapsed * timeMultiplier);
    }

    public function update(t:Float):Void {

    }
}