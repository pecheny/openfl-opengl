package mesh.providers;
import data.IndexCollection;
import mesh.providers.AttrProviders.PosProvider;
class DGridGenerator extends PosProvider {
    var inds:IndexCollection;

    public function new(w, h, hSubd, vSubd) {
        super();
        var triPerLine = (hSubd - 1) * 2 + 1;
        var indCount = triPerLine * hSubd * 3;//138;// (hSubd * vSubd + Math.ceil(vSubd - 1 / 2)) * 6;
        trace("IND: " + indCount);
        inds = new IndexCollection(indCount);

        var yStep = h / vSubd;
        var xStep = w / (hSubd - 1);
        var xOffset = xStep / 2;
        for (iy in 0...vSubd + 1) {
            var y = iy * yStep;
            var even = iy % 2 == 0;
            if (even)
                for (ix in 0...hSubd + 1)
                    addVertex(ix * xStep -xOffset, y);
            else
                for (ix in 0...hSubd)
                    addVertex(ix * xStep , y);
        }
        var i = 0;
        function getInx(ix:Int, iy:Int) {
            var oddCount = Math.ceil(iy / 2) ;
//            var oddCount = Math.ceil((iy +0.5) / 2) - 1;
            var ix1:Int = iy * hSubd + oddCount + ix;//+ ((ix >= hSubd)? 1 : 0);
            trace(ix1);
            if (ix1 >= getVertCount())
                throw 'Wrong $ix, $iy';
            return ix1;
        }
        for (iy in 0...vSubd) {
            var even = iy % 2 == 0;
            if (even) {
                for (ix in 0...hSubd) {
                    inds[i++] = getInx(ix, iy);
                    inds[i++] = getInx(ix, iy + 1);
                    inds[i++] = getInx(ix + 1, iy);
                    if (hSubd - ix == 1)
                        continue;
                    inds[i++] = getInx(ix + 1, iy);
                    inds[i++] = getInx(ix, iy + 1);
                    inds[i++] = getInx(ix + 1, iy + 1);
                }
            } else {
                for (ix in 0...hSubd ) {
                    inds[i++] = getInx(ix, iy);
                    inds[i++] = getInx(ix, iy + 1);
                    inds[i++] = getInx(ix + 1, iy + 1);
                    if (hSubd - ix == 1)
                        continue;
                    inds[i++] = getInx(ix + 1, iy) ;//+ (last? 11 : 0) ;
                    inds[i++] = getInx(ix + 1, iy + 1);
                    inds[i++] = getInx(ix, iy) ;//+ (last? 11 : 0) ;
                }
            }
        }

        trace("Sug ind count " + indCount + ", filled " + i + ", verts: " + getVertCount());

    }

    public function getInds():IndexCollection {
        return inds;
    }

    public function getIndsCount():Int {
        return inds.length;
    }

}
