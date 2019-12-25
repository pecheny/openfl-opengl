package mesh;
import data.AttribSet;
import data.IndexCollection;

class VertDataProviderBase<T:AttribSet> extends VertexAttrDataProvider<T> {
    var indData:IndexCollection;
    var indCount:Int;


    public function getInds():IndexCollection {
        return indData;
    }

    public function getIndsCount():Int {
        return indCount;
    }

    public function setIndData(d:IndexCollection) {
        this.indData = d;
        this.indCount = d.length;
    }


}
