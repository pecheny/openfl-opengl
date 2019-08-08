package bindings;
typedef GLProgram =
#if lime
lime.graphics.opengl.GLProgram
#elseif js
js.html.webgl.Program;
#else
Dynamic
#end

