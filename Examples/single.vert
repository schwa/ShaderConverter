#version 310 es

precision lowp float;

layout(binding = 0) uniform BlockName {
    mat4 modelViewMatrix;
    mat4 projectionMatrix;
};

layout(location = 0) in vec3 position;
layout(location = 0) out vec3 pos;

void main() {

    vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
    gl_Position = projectionMatrix * mvPosition;
    pos = position;
}
