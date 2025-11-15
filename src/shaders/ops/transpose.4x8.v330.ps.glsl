// Implements transposing tensors

#version 330 core

/**
* @algorithm
* As there are 8 render targets, we can output 8 * 16B of data.
* For each element = 32b or 4B, we can output 32 elements.
* So, load 8xint4 per thread and do the transpose inside each "pixel"
**/

uniform usampler2D input;

in vec2 uv;

layout(location = 0) out uvec4 out00;
layout(location = 1) out uvec4 out10;
layout(location = 2) out uvec4 out20;
layout(location = 3) out uvec4 out30;

layout(location = 4) out uvec4 out40;
layout(location = 5) out uvec4 out50;
layout(location = 6) out uvec4 out60;
layout(location = 7) out uvec4 out70;

// The function below implements transpose of 32b elements
// The input tile is 4 x uvec8 and output is 8 x uvec4
// Note that the output layout will not be a proper tensor.
// Each render output will hold consequtive line which means,
// each output buffer will hold 1/8th of the strided rows.
// First output buffer will have 0, 8, 16 rows, 
// second output buffer will  have 1, 9, 17 rows and so on.
void Transpose4B() {
    int x = gl_FragCoord.x;
    int y = gl_FragCoord.y;
    ivec2 coord_input = ivec2(x * 2, y * 4);

    uvec4 in00 = texelFetch(input, ivec2(x * 2, y * 4), 0);
    uvec4 in04 = texelFetch(input, ivec2(x * 2 + 1, y * 4), 0);
    uvec4 in10 = texelFetch(input, ivec2(x * 2, y * 4 + 1), 0);
    uvec4 in14 = texelFetch(input, ivec2(x * 2 + 1, y * 4 + 1), 0);

    uvec4 in20 = texelFetch(input, ivec2(x * 2, y * 4 + 2), 0);
    uvec4 in24 = texelFetch(input, ivec2(x * 2 + 1, y * 4 + 2), 0);
    uvec4 in30 = texelFetch(input, ivec2(x * 2, y * 4 + 3), 0);
    uvec4 in34 = texelFetch(input, ivec2(x * 2 + 1, y * 4 + 3), 0);

    out00.x = in00.x;
    out00.y = in10.x;
    out00.z = in20.x;
    out00.w = in30.x;

    out10.x = in00.y;
    out10.y = in10.y;
    out10.z = in20.y;
    out10.w = in30.y;

    out20.x = in00.z;
    out20.y = in10.z;
    out20.z = in20.z;
    out20.w = in30.z;

    out30.x = in00.w;
    out30.y = in10.w;
    out30.z = in20.w;
    out30.w = in30.w;


    out40.x = in04.x;
    out40.y = in14.x;
    out40.z = in24.x;
    out40.w = in34.x;

    out50.x = in04.y;
    out50.y = in14.y;
    out50.z = in24.y;
    out50.w = in34.y;

    out60.x = in04.z;
    out60.y = in14.z;
    out60.z = in24.z;
    out60.w = in34.z;

    out70.x = in04.w;
    out70.y = in14.w;
    out70.z = in24.w;
    out70.w = in34.w;
}


// This shader implements transpose in a way that 
// all 8 render targets will be in strided fashion


// This shader impelements trsnpose such that each
// thread emits a single 16B
void Transpose4BSingleElement() {
    int x = gl_FragCoord.x;
    int y = gl_FragCoord.y;

    ivec2 coord = ivec2(y, x);

    // load only the first component
    uint a = texelFetch(input, ivec2(y, x), 0).r;
    uint b = texelFetch(input, ivec2(y+1, x), 0).r;
    uint c = texelFetch(input, ivec2(y+2, x), 0).r;
    uint d = texelFetch(input, ivec2(y+3, x), 0).r;

    out00.x = a;
    out00.y = b;
    out00.z = c;
    out00.w = d;
}