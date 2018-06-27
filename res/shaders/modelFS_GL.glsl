#version 450 core

in vec2 pass_texCoords;
in vec3 pass_surfaceNormal;
in vec3 pass_lightVector;
in vec3 pass_cameraVector;
in float fogVisibility;

out vec4 out_Color;

uniform sampler2D modelTexture;
uniform vec3 lightColor;
uniform float shineDamper;
uniform float reflectivity;
uniform vec3 skyColor;

void main() {
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

    /* Transparency Computation */
    vec4 texColor = texture(modelTexture, pass_texCoords);
    if (texColor.a < 0.5) {
        discard;
    }

    out_Color = vec4(diffuse, 1.0) * texColor + vec4(finalSpecular, 1.0f);
    out_Color = mix(vec4(skyColor, 1.0), out_Color, fogVisibility);
}
