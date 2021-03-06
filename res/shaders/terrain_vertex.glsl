layout (location = 0) in vec3 lPosition;
layout (location = 1) in vec3 lNormal;
layout (location = 2) in vec2 lTexCoord;

out vec3 tNormal;
out vec2 tTexCoord;
out vec3 tToLightVector[4];
out vec3 tToCameraVector;
out float tVisibility;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform vec3 uLightPosition[4];

const float density = 0.006;
const float gradient = 1.2;

void main() {
  tTexCoord = lTexCoord;
  tNormal = (uModelMatrix * vec4(lNormal, 0.0)).xyz;

  vec4 worldPosition = uModelMatrix * vec4(lPosition, 1.0);
  for (int i = 0; i < 4; i++) {
    tToLightVector[i] = uLightPosition[i] - worldPosition.xyz;
  }
  tToCameraVector = (inverse(uViewMatrix) * vec4(0.0, 0.0, 0.0, 1.0)).xyz - worldPosition.xyz;

  // Compute exponential heigh fog
  vec4 positionRelativeToCamera = uViewMatrix * worldPosition;
  float distance = length(positionRelativeToCamera.xyz);
  tVisibility = exp(-pow((distance * density), gradient));
  tVisibility = clamp(tVisibility, 0.0, 1.0);

  // Compute vertex position
  gl_Position = uProjectionMatrix * uViewMatrix * worldPosition;
}