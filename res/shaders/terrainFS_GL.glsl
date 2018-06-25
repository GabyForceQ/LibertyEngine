#version 450 core

in vec2 pass_texCoords;
in vec3 pass_surfaceNormal;
in vec3 pass_lightVector;
in vec3 pass_cameraVector;
in float fogVisibility;

out vec4 out_Color;

uniform sampler2D backgroundTexture;
uniform sampler2D rTexture;
uniform sampler2D gTexture;
uniform sampler2D bTexture;
uniform sampler2D blendMap;
uniform vec3 lightColor;
uniform float shineDamper;
uniform float reflectivity;
uniform vec3 skyColor;

void main() {
    vec4 blendMapColor = texture(blendMap, pass_texCoords);
    float backTexAmount = 1 - (blendMapColor.r + blendMapColor.g + blendMapColor.b);
    vec2 tiledTexCoords = pass_texCoords * 32.0f;
    vec4 backgroundTexColor = texture(backgroundTexture, tiledTexCoords) * backTexAmount;
    vec4 rTexColor = texture(rTexture, tiledTexCoords) * blendMapColor.r;
    vec4 gTexColor = texture(gTexture, tiledTexCoords) * blendMapColor.g;
    vec4 bTexColor = texture(bTexture, tiledTexCoords) * blendMapColor.b;
    vec4 totalColor = backgroundTexColor + rTexColor + gTexColor + bTexColor;
    vec3 unitNormal = normalize(pass_surfaceNormal);
    vec3 unitLightVector = normalize(pass_lightVector);
    float dotProduct = dot(unitNormal, unitLightVector);
    float brightness = max(dotProduct, 0.2);
    vec3 diffuse = brightness * lightColor;
    vec3 unitVectorToCamera = normalize(pass_cameraVector);
    vec3 lightDirection = -unitLightVector;
    vec3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    float specularFactor = dot(reflectedLightDirection, unitVectorToCamera);
    specularFactor = max(specularFactor, 0.0f);
    float dampedFactor = pow(specularFactor, shineDamper);
    vec3 finalSpecular = dampedFactor * reflectivity * lightColor;
    out_Color = vec4(diffuse, 1.0) * totalColor + vec4(finalSpecular, 1.0f);
    out_Color = mix(vec4(skyColor, 1.0), out_Color, fogVisibility);
}
