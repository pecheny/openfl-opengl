package tools;
import mesh.serialization.data.MeshRecord;
class MeshCollectionWriter {
    public var meshes = new Map<String, MeshRecord>();
    public function new() {
    }

    public function add(name, mesh) {
        meshes.set(name, mesh);
    }

}
