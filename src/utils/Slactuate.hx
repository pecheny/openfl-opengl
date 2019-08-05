package utils;

class Slactuate {
    /* how to use: build your own abstraction on m() and p() to ease the setting of properties. call u() each frame you update, then call c() to cleanup. */


    private static inline function clamp(pct) { return Math.min(1., Math.max(0., pct)); }

    public static inline function lerp/*unclamped*/(pct:Float, lo:Float, ho:Float):Float { return (ho - lo) * pct + lo; }

    public static function linear(pct:Float, lo:Float, ho:Float):Float { return lerp(clamp(pct), lo, ho); }

    public static function smoothstep(pct:Float, lo:Float, ho:Float):Float { var x = clamp(pct); return lerp(x * x * x * (x * (x * 6 - 15) + 10), lo, ho); }

}

