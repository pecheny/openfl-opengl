package tools;
class SaveJson {

    public static function save(file, data) {
        var fs = sys.io.File.write(file);
        fs.writeString(haxe.Json.stringify(data, null, " "));
        fs.close();
    }
}
