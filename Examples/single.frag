#version 310 es

precision lowp float;

layout(binding = 0) uniform Uniforms {
    float v;
};

layout(binding = 0) uniform sampler2D tex1;
layout(location = 1) in vec3 pos;
layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = texture(tex1, pos.xy) * v;
}
