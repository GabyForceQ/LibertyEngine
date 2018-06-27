#version 450 core

in vec3 position;
in vec2 texCoords;
in vec3 normal;

out vec2 pass_texCoords;
out vec3 pass_surfaceNormal;
out vec3 pass_lightVector;
out vec3 pass_cameraVector;
out float fogVisibility;

uniform mat4 transformationMatrix;
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform vec3 lightPosition;

const float fogDensity = 0.005;
const float fogGradient = 1.5;

void main() {
    vec4 worldPosition = transformationMatrix * vec4(position, 1.0f);
    vec4 relativePosToCamera = viewMatrix * worldPosition;
    gl_Position = projectionMatrix * relativePosToCamera;
    pass_texCoords = texCoords;
    pass_surfaceNormal = (transformationMatrix * vec4(normal, 0.0f)).xyz;
    pass_lightVector = lightPosition - worldPosition.xyz;
    pass_cameraVector = (inverse(viewMatrix) * vec4(0.0f, 0.0f, 0.0f, 1.0f)).xyz - worldPosition.xyz;
    /* Compute Fog Visibility */
    float distance = length(relativePosToCamera.xyz);
    fogVisibility = exp(-pow((distance * fogDensity), fogGradient));
    fogVisibility = clamp(fogVisibility, 0.0, 1.0);
}
