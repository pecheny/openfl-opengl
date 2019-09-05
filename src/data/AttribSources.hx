package data;
typedef ASMap = Map<String, VertexAttribProvider>;
@:forward
abstract AttribSources<T:AttribSet>(ASMap) to ASMap from ASMap {
    public inline function new () this = new Map();

    public inline function with<T:AttribSet>(name, src):AttribSources<T> {
        this.set(name, src);
        return cast this;
    }
}
