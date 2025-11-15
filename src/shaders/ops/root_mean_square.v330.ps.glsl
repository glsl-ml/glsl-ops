// Implements different sections of root-mean-squared layer

#version 330 core

/// Compute squares and do partial reduction

uniform sampler2D input;

in vec2 uv;

layout(location = 0) out float outSquareSum;

// We assume that the reduction dimension happens in the leading dimension
// of a 2D tensor. The strided dimension is the folded dimension of a Nd tensor.
// A tensor of N-dimension is folded into 2-dimension where leading-dimension of
// Nd tensor becomes leading dimension of 2d tensor. All other (N-1) dimensions
// are folded into the strided dimension of 2d tensor.
//
// @todo Add different shaders for different strides folded in the 2nd dimension
// A careful study of how the partial-sum and final-sum should be done
// The code below is WIP
float SquareAndPartialSum() {
    // Load 8 float4s or 128B.
    // We picked randomly so that we don't run out of registers and wait counts 
    // to track the loads.

    // Compute coordinates
    ivec2 size = textureSize(input, 0);

    #define NUM_VFLOATS 8

    vec4 acc = vec4(0.0);
    int base = int(uv.x * size.x);

    for(int i = 0; i < NUM_VFLOATS; i++) {
        vec4 v = texelFetch(tex, ivec2(base + i * NUM_VFLOATS, 0), 0);
        acc += v * v;
    }

    return acc.x + acc.y + acc.z + acc.w;
}

void main() {
    outSquareSum = SquareAndPartialSum();
}
