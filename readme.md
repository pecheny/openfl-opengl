Trying to built in custom OpenGL renderer into  OpenFL rendering pipeline.
For now targeting to Windows (+android) only.

### The sample

Two display object, each of them render its own data with its own shader.

OGLContainer renders one triangle with vertex color.

OGLContainerCopy renders mirrored triangle with offset and color hardcoded into the shader.

### Issues

1. If i put any other Sprite with non-empty graphics, the app crashes on first (?invalidate()/update())
2. Two mirrored triangles render well as long as i do not call invalidate() or move/resize window. After any of those actions shader of second object renders the same data as first (i can see both triangles thanks to offset hardcoded into the shader).
I don't know if the data of first VBO is overwritten or the both sharer program got reference to same VBO. I have noted this effect even if VBOs had different sets of attributes.

### Versions

Fresh develop branches on 2/10/19

OpenFL 231d183500d2e386c74806dfa4b07632ff7f5259

Lime d9dbea7f6bbfa97a853b98f81bf169bcc0573dd0

Haxe Compiler 4.0.0-preview.5+7eb789f54


