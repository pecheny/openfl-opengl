package utils;
#if macro
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end
class EmbedLocalFile {

    public static macro function embedJsonAsset(filename:String) {
        var filePath:String = Path.join(["./Assets", filename]);
        if (FileSystem.exists(filePath)) {
            var fileContent:String = File.getContent(filePath);
            return macro haxe.Json.parse($v{fileContent});
        }  else {
           throw "Wrong file";
        }
    }


}
