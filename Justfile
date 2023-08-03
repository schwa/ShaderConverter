CONTAINER := "shaderc"

# build the container! prefer this over `build_quiet` for manual builds so you can see any errors
build:
    docker build --platform linux/amd64 -t shaderc .

# build the container, but don't show any output
build_quiet:
    docker build --platform linux/amd64 -t shaderc . 2> /dev/null

# convenience for running a command within the container
run SRC +ARGS:
    docker run -it --rm --mount type=bind,src={{SRC}},target=/src --workdir /src shaderc {{ARGS}}

copy-artifacts: build_quiet
    just run . cp -r /root/shaderc-version.txt artifacts
    just run . cp -r /root/SPIRV-Cross-version.txt artifacts
    just run . glslc --help > artifacts/glslc--help.txt
    just run . spirv-cross --help > artifacts/spirv-cross--help.txt

sh: build_quiet
    just run . sh

glsl_to_spirv INPUT OUTPUT: build_quiet
    just run . \
        glslc {{INPUT}} -o {{OUTPUT}}

spirv_to_metal INPUT OUTPUT OLD_ENTRY_POINT NEW_ENTRY_POINT STAGE: build_quiet
    just run . \
        spirv-cross --msl {{INPUT}} --rename-entry-point {{OLD_ENTRY_POINT}} {{NEW_ENTRY_POINT}} {{STAGE}} > {{OUTPUT}}

example:
    just glsl_to_spirv "Examples/single.frag" "Examples/single_frag.spv"
    just spirv_to_metal "Examples/single_frag.spv" "Examples/single_frag.metal" "main" "single_frag" "frag"

    just glsl_to_spirv "Examples/single.vert" "Examples/single_vert.spv"
    just spirv_to_metal "Examples/single_vert.spv" "Examples/single_vert.metal" "main" "single_vert" "vert"
