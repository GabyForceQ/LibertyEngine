layout (location = 0) in vec3 lPosition;

out vec3 tTexCoord;

uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;

void main() {
  tTexCoord = vec3(lPosition.x, -1.0 * lPosition.y, lPosition.z);

  gl_Position = uProjectionMatrix * uViewMatrix * vec4(lPosition, 1.0);
}