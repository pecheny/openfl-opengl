Custom OpenGL renderer within OpenFL display list.
Works on windows, android and html5 targets.

### The sample

Two display object, each of them render its own data with its own shader.

OGLContainer renders one triangle with vertex color.

OGLContainerCopy renders mirrored triangle with offset and color hardcoded into the shader.

### Issues

1. ~If i put any other Sprite with non-empty graphics, the app crashes on first (?invalidate()/update()).~

 Resolved with adding define @openfl_disable_context_cache@

### Versions

Fresh develop branches on 3/4/19

OpenFL f30f86abe0a2433a557a1fe4fe43d285d74cba8d

Lime d1cd3be6863f3bb65168b85418f37b4856601fac

hxcpp [4.0.4]

Haxe Compiler 4.0.0-preview.5+7eb789f54


