in vec3 tTexCoord;
      
uniform samplerCube uCubeMap;
uniform vec3 uFogColor;

uniform float uFadeLowerLimit;
uniform float uFadeUpperLimit;

void main() {
  vec4 finalColor = texture(uCubeMap, tTexCoord);

  float factor = (-1.0 * tTexCoord.y - uFadeLowerLimit) / (uFadeUpperLimit - uFadeLowerLimit);
  factor = clamp(factor, 0.0, 1.0);

  gl_FragColor = mix(vec4(uFogColor, 1.0), finalColor, factor);
}