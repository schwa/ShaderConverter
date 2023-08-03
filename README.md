# README.md

## What is this?

This is a Dockerfile and a Justfile script to build a Docker image for the recompiling graphics shaders. My primary focus is supporting recompiling GLSL shaders into Metal Shading Language. But there are enough tools here to convert many other shader formats.

It currently includes [shaderc](https://github.com/google/shaderc/issues/1306) and [SPIRV-Cross](https://github.com/KhronosGroup/SPIRV-Cross).

Shaderc itself includes a bunch of dependencies, including `glslc` (and `glslang`), which will allow you to convert GLSL (among other formats) shaders to SPIR-V.

SPIRV-Cross can convert SPIR-V to Metal Shading Language (and other formats).

SPIR-V is used as an intermediate format for conversion.

## How do I use it?

You'll require docker, but on macOS, I highly recommend [OrbStack](https://orbstack.dev) instead. You'll also need [Just](https://just.systems) to run the tasks within the provided [Justfile](Justfile) directly. But if you don't want to use Just, you can just copy and paste the shell script commands contained within the Justfile itself.

If you're using this project to set up your own Dockerfile be aware that this needs a "linux/amd64" docker container. See the 'build' rule of the [Justfile](Justfile) for more information.

If you have [Just](https://just.systems) installed you can build everything with `just build`. On my M1 16"-MBP this takes approximately 5 minutes. Then take a look at the `example` rule in the [Justfile](Justfile) for examples showing how to convert GLSL shaders to Metal Shading Language (and change the entry point name).

There's also help for both [glslc](artifacts/glslc--help.txt) and [SPIRV-Cross](artifacts/spirv-cross--help.txt) within the [artifacts](artifacts) directory to help you get started.

## What binaries are included?

```sh
$ just sh
$ ls /usr/local/bin
glslang           glslc     spirv-cfg    spirv-dis          spirv-link  spirv-objdump  spirv-reduce  spirv-val
glslangValidator  spirv-as  spirv-cross  spirv-lesspipe.sh  spirv-lint  spirv-opt      spirv-remap
```

## Doesn't Apple's Metal Shader Converter do this?

I don't think so. [Apple's tool](https://developer.apple.com/metal/shader-converter/) converts from shaders in LLVM/IR format to MSL. Currently, only (Windows) DirectX DXIL format shaders seem supported.

## What about WebGL?

You may need to convert your WebGL shaders to GLSL-Es "style" first. Add `#version 310 es` to the front of your shader files and then fix the errors `glslc` gives you. See [Examples](#examples) for more help.

## Why are you doing this?

Because I haven't found a better way than writing my own Dockerfile. None of these tools are available in any of the standard package managers (brew, etc). Installing them on arm64 macOS requires a ton of dependencies and troubleshooting architecture issues. I also haven't found (but to be honest didn't spend a lot of time looking) a pre-built docker image that includes all of these tools either.

## Why aren't you simply using _____?

I haven't found any of this stuff to be simple. But if there's a better solution let me [know](https://schwa.io).
