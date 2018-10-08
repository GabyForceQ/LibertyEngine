/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shaders.d, _shaders.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shaders;

import liberty.core.engine : CoreEngine;
import liberty.graphics.shader : GfxShader;

/**
 *
**/
immutable CORE_VERTEX = q{
  #version 330 core

  layout (location = 0) in vec3 lPosition;
  layout (location = 1) in vec3 lNormal;
  layout (location = 2) in vec2 lTexCoord;

  // Represented in WorldSpace
  out vec3 tPosition;
  out vec3 tNormal;
  out vec2 tTexCoord;
  
  uniform mat4 uModelMatrix;
  uniform mat4 uViewMatrix;
  uniform mat4 uProjectionMatrix;

  void main()
  {
    tPosition = vec3(uModelMatrix * vec4(lPosition, 1.0));
    tTexCoord = vec2(lTexCoord.x, -lTexCoord.y);
    tNormal = mat3(transpose(inverse(uModelMatrix))) * lNormal;

    // Compute vertex position
    gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(lPosition, 1.0);
  }
};

/**
 *
**/
immutable CORE_FRAGMENT = q{
  #version 330 core

  in vec3 tPosition;
  in vec3 tNormal;
  in vec2 tTexCoord;

  struct Material {
    sampler2D diffuse;
    vec3 specular;

    float shininess;
  };

  struct Light {
    vec3 position;
    vec3 direction;
    float cutOff;
    float outerCutOff;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float constant;
    float linear;
    float quadratic;
  };

  uniform	vec3 uViewPosition;
  uniform Material uMaterial;
  uniform Light uLight;
  
  void main()
  {
    // ambient
    vec3 ambient = uLight.ambient * texture(uMaterial.diffuse, tTexCoord).rgb;
  	
    // diffuse 
    vec3 norm = normalize(tNormal);
    vec3 lightDir = normalize(uLight.position - tPosition);
    
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = uLight.diffuse * diff * texture(uMaterial.diffuse, tTexCoord).rgb;  
    
    // specular
    vec3 viewDir = normalize(uViewPosition - tPosition);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), uMaterial.shininess);
    vec3 specular = uLight.specular * (spec * uMaterial.specular);

    // spotlight (soft edges)
    float theta = dot(lightDir, normalize(-uLight.direction)); 
    float epsilon = (uLight.cutOff - uLight.outerCutOff);
    float intensity = clamp((theta - uLight.outerCutOff) / epsilon, 0.0, 1.0);
    diffuse  *= intensity;
    specular *= intensity;
    
    // attenuation
    float distance = length(uLight.position - tPosition);
    float attenuation = 1.0 / (uLight.constant + uLight.linear * distance + uLight.quadratic * (distance * distance));    
    ambient *= attenuation; 
    diffuse *= attenuation;
    specular *= attenuation; 
        
    vec3 result = ambient + diffuse + specular;
    gl_FragColor = vec4(result, 1.0);
  }
};