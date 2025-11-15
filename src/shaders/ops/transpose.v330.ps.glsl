// Implements transposing tensors

#version 330 core

/**
* @algorithm
* This is a simple transpose where a "pixel" loads a single element
* and stores it into a output in transposed coordinate.
**/

uniform sampler2D input;

in vec2 uv;

layout(location = 0) out uint output;

// The function below implements transpose of 32b elements
// The input tile is 4 x uvec8 and output is 8 x uvec4
void Transpose4B() {
    ivec2 coord_input = ivec2(gl_FragCoord.y, gl_FragCoord.x);

    uint v = texelFetch(input, coord_input, 0);
    output = v;
}
