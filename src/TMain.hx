package ;
import bindings.WebGLRenderContext as Gl;
import js.Browser;
import js.html.CanvasElement;
import js.lib.Float32Array;

class TMain {
    public function new() {
        trace("hi");
    }

    public static function main() {
        new TMain();

        /* Step1: Prepare the canvas and get WebGL context */
        var vertices = [-0.5, 0.5, -0.5, -0.5, 0.0, -0.5,];

        var canvas:CanvasElement = cast Browser.document.getElementById("my_Canvas");
        var gl:Gl = canvas.getContextWebGL2({});

        /* Step2: Define the geometry and store it in buffer objects */

        var vertex_buffer = gl.createBuffer();

        // Bind an empty array buffer to it
        gl.bindBuffer(Gl.ARRAY_BUFFER, vertex_buffer);

        // Pass the vertices data to the buffer
        gl.bufferData(Gl.ARRAY_BUFFER, new Float32Array(vertices), Gl.STATIC_DRAW);

        // Unbind the buffer
        gl.bindBuffer(Gl.ARRAY_BUFFER, null);

        /* Step3: Create and compile Shader programs */

        // Vertex shader source code
        var vertCode =
        'attribute vec2 coordinates;' +
        'void main(void) {' + ' gl_Position = vec4(coordinates,0.0, 1.0);' + '}';

        //Create a vertex shader object
        var vertShader = gl.createShader(Gl.VERTEX_SHADER);

        //Attach vertex shader source code
        gl.shaderSource(vertShader, vertCode);

        //Compile the vertex shader
        gl.compileShader(vertShader);

        //Fragment shader source code
        var fragCode = 'void main(void) {' + 'gl_FragColor = vec4(0.0, 0.0, 0.0, 0.1);' + '}';

        // Create fragment shader object
        var fragShader = gl.createShader(Gl.FRAGMENT_SHADER);

        // Attach fragment shader source code
        gl.shaderSource(fragShader, fragCode);

        // Compile the fragment shader
        gl.compileShader(fragShader);

        // Create a shader program object to store combined shader program
        var shaderProgram = gl.createProgram();

        // Attach a vertex shader
        gl.attachShader(shaderProgram, vertShader);

        // Attach a fragment shader
        gl.attachShader(shaderProgram, fragShader);

        // Link both programs
        gl.linkProgram(shaderProgram);

        // Use the combined shader program object
        gl.useProgram(shaderProgram);

        /* Step 4: Associate the shader programs to buffer objects */

        //Bind vertex buffer object
        gl.bindBuffer(Gl.ARRAY_BUFFER, vertex_buffer);

        //Get the attribute location
        var coord = gl.getAttribLocation(shaderProgram, "coordinates");

        //point an attribute to the currently bound VBO
        gl.vertexAttribPointer(coord, 2, Gl.FLOAT, false, 0, 0);

        //Enable the attribute
        gl.enableVertexAttribArray(coord);

        /* Step5: Drawing the required object (triangle) */

        // Clear the canvas
        gl.clearColor(0.5, 0.5, 0.5, 0.9);

        // Enable the depth test
        gl.enable(Gl.DEPTH_TEST);

        // Clear the color buffer bit
        gl.clear(Gl.COLOR_BUFFER_BIT);

        // Set the view port
        gl.viewport(0, 0, canvas.width, canvas.height);

        // Draw the triangle
        gl.drawArrays(Gl.TRIANGLES, 0, 3);
    }
}
