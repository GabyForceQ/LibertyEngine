in vec3 tNormal;
in vec2 tTexCoord;
in vec3 tToLightVector[4];
in vec3 tToCameraVector;
in float tVisibility;

uniform sampler2D uBackgroundTexture;
uniform sampler2D uRTexture;
uniform sampler2D uGTexture;
uniform sampler2D uBTexture;
uniform sampler2D uBlendMap;

uniform vec2 uTexCoordMultiplier;
uniform vec3 uLightColor[4];
uniform vec3 uLightAttenuation[4];
uniform float uShineDamper;
uniform float uReflectivity;
uniform vec3 uSkyColor;

void main() {
  // Compute terrain textures
  vec4 blendMapColor = texture(uBlendMap, tTexCoord);
  float backTextureAmount = 1 - (blendMapColor.r + blendMapColor.g + blendMapColor.b);
  vec2 tiledTexCoords = tTexCoord * uTexCoordMultiplier;
  vec4 backgroundTextureColor = texture(uBackgroundTexture, tiledTexCoords) * backTextureAmount;
  vec4 rTextureColor = texture(uRTexture, tiledTexCoords) * blendMapColor.r;
  vec4 gTextureColor = texture(uGTexture, tiledTexCoords) * blendMapColor.g;
  vec4 bTextureColor = texture(uBTexture, tiledTexCoords) * blendMapColor.b;
  vec4 totalTextureColor = backgroundTextureColor + rTextureColor + gTextureColor + bTextureColor;

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

  // Mix sky color with finalTexture
  gl_FragColor = mix(vec4(uSkyColor, 1.0), vec4(totalDiffuse, 1.0)
    * totalTextureColor + vec4(totalSpecular, 1.0), tVisibility);
}