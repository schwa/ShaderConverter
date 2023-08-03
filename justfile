build:
    docker build --platform linux/amd64 -t shaderc .

build_quiet:
    docker build --platform linux/amd64 -t shaderc . 2> /dev/null

sh: build_quiet
    docker run -it --rm --mount type=bind,src="$(pwd)",target=/src --workdir /src shaderc \
        sh

glsl_to_spirv INPUT OUTPUT: build_quiet
    docker run -it --rm --mount type=bind,src="$(pwd)",target=/src --workdir /src shaderc \
        glslc {{INPUT}} -o {{OUTPUT}}

spirv_to_metal INPUT OUTPUT OLD_ENTRY_POINT NEW_ENTRY_POINT STAGE: build_quiet
    docker run -it --rm --mount type=bind,src="$(pwd)",target=/src --workdir /src shaderc \
        spirv-cross --msl {{INPUT}} --rename-entry-point {{OLD_ENTRY_POINT}} {{NEW_ENTRY_POINT}} {{STAGE}} > {{OUTPUT}}

example:
    just glsl_to_spirv "single.frag" "temp/single_frag.spv"
    just spirv_to_metal "temp/single_frag.spv" "output/single_frag.metal" "main" "single_frag" "frag"
