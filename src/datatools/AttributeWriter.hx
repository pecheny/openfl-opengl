package datatools;

import datatools.ValueWriter.IValueWriter;
import data.AttributeDescr;
class Attribute2Writer<T> {
    var a:IValueWriter;
    var b:IValueWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = ValueWriter.create(target, attr, 0, stride);
        b = ValueWriter.create(target, attr, 0, stride);
    }

    public function setValue(i, a, b) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
    }
}

class Attribute3Writer<T> {
    var a:IValueWriter;
    var b:IValueWriter;
    var c:IValueWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = ValueWriter.create(target, attr, 0, stride);
        b = ValueWriter.create(target, attr, 1, stride);
        c = ValueWriter.create(target, attr, 2, stride);
    }

    public function setValue(i, a, b, c) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
        this.c.setValue(i, c);
    }
}

class Attribute4Writer<T> {
    var a:IValueWriter;
    var b:IValueWriter;
    var c:IValueWriter;
    var d:IValueWriter;

    public function new(target:ByteDataWriter, attr:AttributeDescr, stride:Int) {
        a = ValueWriter.create(target, attr, 0, stride);
        b = ValueWriter.create(target, attr, 1, stride);
        c = ValueWriter.create(target, attr, 2, stride);
        d = ValueWriter.create(target, attr, 3, stride);
    }

    public function setValue(i, a, b, c, d) {
        this.a.setValue(i, a);
        this.b.setValue(i, b);
        this.c.setValue(i, c);
        this.d.setValue(i, d);
    }
}

