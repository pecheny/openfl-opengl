package tools;
import mesh.MeshWriter;
import mesh.VertexAttribProvider;
import sys.io.File;
@:keep
class MeshFileWriter {
    var dataWriter:MeshWriter;

    public static function main() {
        new MeshFileWriter();
    }

    public function new() {
        dataWriter = new MeshWriter();
//        var pos = new TriPosProvider(1, -1);
//        var indPr = i -> i;
//        regProviders(pos.getPos, indPr);
//        witeFiles(3,1,"my_tri");
    }

    public function regProviders(pp:VertexAttribProvider, ip:Int -> Int) {
        dataWriter.addPosProvider(pp);
        dataWriter.adIndProvider(ip);
    }

    public function addCustomProvider(name, prov) {
        dataWriter.addCustomProvider(name, prov);
    }

    public function witeFiles(vertCount, triCount, path) {
        if (!sys.FileSystem.isDirectory(path))
            sys.FileSystem.createDirectory(path);
        dataWriter.fetch(vertCount, triCount);

        var stream = File.write(path + "/bytes");
        stream.write(dataWriter.getVerts());
        stream.close();

        stream = File.write(path + "/inds");
        stream.write(dataWriter.getInds());
        stream.close();
    }


}
