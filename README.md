# glsl-ops
This project contains glsl vertex and pixel shaders for different deep learning operations.

The goal of this project is to teach or curate the older techniques of how GPU programing was done before GPGPU improvements are brought to GPUs and programming standards. We learn the key drawbacks that held these GPUs back for GPGPU programming and using the knowledge of current GPGPU programming, one could deduce how things have evolved in GPUs. Also, these GPUs are the only programmable VLIW hardware we can get our hands on and this is a good exercise to figure out the merits and drawbacks of how ATI/AMD implemented the VLIW architecture. I know that there are other VLIW architectures out there but the programmability of them requires a lot of setup but ATI/AMD GPUs have excellent open source OpenGL support via Mesa (have to test thoroughly).


The motivation is to run these ops on AMD GPUs on and after R600 which introduced unified shader architecture that made graphics programmable.
The table below shows the OpenGL and GLSL spec for GPUs until GCN was introduced 

|GPU Architecture|Radeon Series|OpenGL Version|Vulkan Version|
|--|--|--|--|
|R600 (TeraScale 1, VLIW5)|HD 2000| 3.3 |❌|
|R670 (TeraScale 1, VLIW5)|HD 3000| 3.3 |❌|
|R700 (TeraScale 1, VLIW5)|HD 4000| 3.3 |❌|
|Evergreen (TeraScale 2, VLIW5)|HD 5000| 4.6 |❌|
|Northern Islands (TeraScale 2, VLIW5 upto 68xx)|HD 6000| 4.6 |❌|
|Northern Islands (TeraScale 3, VLIW4 upto 69xx)|HD 6000| 4.6 |1.1|

For version 3.3, we have to use vertex and pixel shaders to implement the ops.
For version 4.6, we can use compute shaders and ssbo.
Which means, we have to implement 2 versions of same operations (fun!).

As these GPUs are VLIW rather an super-scalar, it takes different kinds of optimizations to exploit their performance.

## Code design for GLSL 3.3
For version 3.3, there are multiple limitations to write a true shader which behaves like C/C++ code (accessing memory).

1. The operations can only run on pixel shaders.
2. As we have to use pixel shader to implement the ops, the output per thread will always be a 128b value per render target (more on this later).
3. As there are only 8 render targets (think of them as number of frames GPU can process at a single time), the maximum amount of data that can be output by a shader are 8 * 128b = 1024b (128B).
4. The only way to access data inside pixel shaders is via textures.
5. Most of the time, you are limited by the VRAM on the GPU. The GPUs under GLSL 3.3 have memory in the orders of MB (mega bytes).

## Code design for GLSL 4.6
TBD

## Expectations
These are the expectations/assumptions about the systems that are hosting these GPUs to run these shaders.

1. There is atleast 16GB of CPU DRAM. (This is required to hold inputs, intermediates and outputs of operations)
2. There is atleast 256GB of fast NVMe storage. (This is required to hold inter-stage data especially kv-cache and such).
