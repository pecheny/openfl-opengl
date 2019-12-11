package datatools;

class Attribute2Writer<T> {
    var a:ValueWriter<T>;
    var b:ValueWriter<T>;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = new ValueWriter(target, attr, 0, stride);
        b = new ValueWriter(target, attr, 0, stride);
    }

    public function setValue(i, a, b) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
    }
}

class Attribute3Writer<T> {
    var a:ValueWriter<T>;
    var b:ValueWriter<T>;
    var c:ValueWriter<T>;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = new ValueWriter(target, attr, 0, stride);
        b = new ValueWriter(target, attr, 1, stride);
        c = new ValueWriter(target, attr, 2, stride);
    }

    public function setValue(i, a, b, c) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
        this.c.setValue(i, c);
    }
}

class Attribute4Writer<T> {
    var a:ValueWriter<T>;
    var b:ValueWriter<T>;
    var c:ValueWriter<T>;
    var d:ValueWriter<T>;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = new ValueWriter(target, attr, 0, stride);
        b = new ValueWriter(target, attr, 1, stride);
        c = new ValueWriter(target, attr, 2, stride);
        d = new ValueWriter(target, attr, 3, stride);
    }

    public function setValue(i, a, b, c, d) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
        this.c.setValue(i, c);
        this.d.setValue(i, d);
    }
}

