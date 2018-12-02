/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.shader;

import std.conv : to;

import liberty.math.matrix;
import liberty.math.vector;
import liberty.graphics.shader;

/**
 *
**/
final class TerrainShader : GfxShaderProgram {
  private {
    static immutable TERRAIN_VERTEX = GFX_SHADER_CORE_VERSION ~ q{
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
    };

    static immutable TERRAIN_FRAGMENT = GFX_SHADER_CORE_VERSION ~ q{
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
    };
  }

  /**
   *
  **/
  this() {
    this
      .compileShaders(TERRAIN_VERTEX, TERRAIN_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lNormal")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uModelMatrix")
      .addUniform("uViewMatrix")
      .addUniform("uProjectionMatrix")
      .addUniform("uLightPosition[0]")
      .addUniform("uLightPosition[1]")
      .addUniform("uLightPosition[2]")
      .addUniform("uLightPosition[3]")
      .addUniform("uLightColor[0]")
      .addUniform("uLightColor[1]")
      .addUniform("uLightColor[2]")
      .addUniform("uLightColor[3]")
      .addUniform("uLightAttenuation[0]")
      .addUniform("uLightAttenuation[1]")
      .addUniform("uLightAttenuation[2]")
      .addUniform("uLightAttenuation[3]")
      .addUniform("uBackgroundTexture")
      .addUniform("uRTexture")
      .addUniform("uGTexture")
      .addUniform("uBTexture")
      .addUniform("uBlendMap")
      .addUniform("uShineDamper")
      .addUniform("uReflectivity")
      .addUniform("uTexCoordMultiplier")
      .addUniform("uSkyColor")
      .loadBackgroundTexture(0)
      .loadRTexture(1)
      .loadGTexture(2)
      .loadBTexture(3)
      .loadBlendMap(4)
      .unbind();
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadModelMatrix(Matrix4F matrix) {
    super.loadUniform("uModelMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadViewMatrix(Matrix4F matrix) {
    super.loadUniform("uViewMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadProjectionMatrix(Matrix4F matrix) {
    super.loadUniform("uProjectionMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadLightPosition(uint index, Vector3F position) {
    super.loadUniform("uLightPosition[" ~ index.to!string ~ "]", position);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadLightColor(uint index, Vector3F color) {
    super.loadUniform("uLightColor[" ~ index.to!string ~ "]", color);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadLightAttenuation(uint index, Vector3F attenuation) {
    super.loadUniform("uLightAttenuation[" ~ index.to!string ~ "]", attenuation);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadBackgroundTexture(int id) {
    super.loadUniform("uBackgroundTexture", id);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadRTexture(int id) {
    super.loadUniform("uRTexture", id);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadGTexture(int id) {
    super.loadUniform("uGTexture", id);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadBTexture(int id) {
    super.loadUniform("uBTexture", id);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadBlendMap(int id) {
    super.loadUniform("uBlendMap", id);
    return this;
  }
  
  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadShineDamper(float value) {
    super.loadUniform("uShineDamper", value);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadReflectivity(float value) {
    super.loadUniform("uReflectivity", value);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadTexCoordMultiplier(Vector2F multiplier) {
    super.loadUniform("uTexCoordMultiplier", multiplier);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadSkyColor(Vector3F color) {
    super.loadUniform("uSkyColor", color);
    return this;
  }
}