package transform;
import datatools.VertValueProvider;
interface TransformFactory {
    function getTransform(attribute:String, a:VertValueProvider):VertValueProvider;
}

