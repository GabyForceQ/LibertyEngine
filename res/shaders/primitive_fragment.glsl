in vec3 tNormal;
in vec2 tTexCoord;
in vec3 tToLightVector[4];
in vec3 tToCameraVector;
in float tVisibility;

uniform sampler2D uTexture;
uniform vec3 uLightColor[4];
uniform vec3 uLightAttenuation[4];
uniform float uShineDamper;
uniform float uReflectivity;
uniform vec3 uSkyColor;

void main() {
  vec3 unitNormal = normalize(tNormal);
  vec3 unitVectorToCamera = normalize(tToCameraVector);

  vec3 totalDiffuse = vec3(0.0);
  vec3 totalSpecular = vec3(0.0);

  for (int i = 0; i < 4; i++) {
    float distance = length(tToLightVector[i]);
    float attenuationFprimitive = uLightAttenuation[i].x + 
      (uLightAttenuation[i].y * distance) + 
      (uLightAttenuation[i].z * distance * distance);
    vec3 unitLightVector = normalize(tToLightVector[i]);

    float dotComputation = dot(unitNormal, unitLightVector);
    float brightness = max(dotComputation, 0.0);
    vec3 lightDirection = -unitLightVector;
    vec3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    float specularFprimitive = dot(reflectedLightDirection, unitVectorToCamera);
    specularFprimitive = max(specularFprimitive, 0.0);
    float dampedFprimitive = pow(specularFprimitive, uShineDamper);
    totalDiffuse += (brightness * uLightColor[i]) / 2*attenuationFprimitive;
    totalSpecular += (dampedFprimitive * uReflectivity * uLightColor[i]) / 2*attenuationFprimitive;
  }

  totalDiffuse = max(totalDiffuse, 0.4);

  // Compute alpha channel of final texture if necessary
  vec4 finalTexture = texture(uTexture, tTexCoord);
  if (finalTexture.a < 0.5)
    discard;

  // Mix sky color with finalTexture
  gl_FragColor = mix(vec4(uSkyColor, 1.0), vec4(totalDiffuse, 1.0)
    * finalTexture + vec4(totalSpecular, 1.0), tVisibility);
}