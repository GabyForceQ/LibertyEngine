/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/terrain.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.terrain;

import liberty.core.math.matrix : Matrix4F;
import liberty.core.math.vector : Vector3F;
import liberty.graphics.shader.impl : GfxShader;

/**
 *
**/
class GfxTerrainShader : GfxShader {
  private {
    static immutable TERRAIN_VERTEX = q{
      #version 330 core

      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec3 lNormal;
      layout (location = 2) in vec2 lTexCoord;

      out vec3 tNormal;
      out vec2 tTexCoord;
      out vec3 tToLightVector;
      out vec3 tToCameraVector;
      
      uniform mat4 uModelMatrix;
      uniform mat4 uViewMatrix;
      uniform mat4 uProjectionMatrix;
      uniform vec3 uLightPosition;

      void main() {
        tTexCoord = vec2(lTexCoord.x, -lTexCoord.y) * 40.0;
        tNormal = (uModelMatrix * vec4(lNormal, 0.0)).xyz;

        vec4 worldPosition = uModelMatrix * vec4(lPosition, 1.0);
        tToLightVector = uLightPosition - worldPosition.xyz;
        tToCameraVector = (inverse(uViewMatrix) * vec4(0.0, 0.0, 0.0, 1.0)).xyz - worldPosition.xyz;

        // Compute vertex position
        gl_Position = uProjectionMatrix * uViewMatrix * worldPosition;
      }
    };

    static immutable TERRAIN_FRAGMENT = q{
      #version 330 core

      in vec3 tNormal;
      in vec2 tTexCoord;
      in vec3 tToLightVector;
      in vec3 tToCameraVector;

      uniform sampler2D uTexture;
      uniform vec3 uLightColor;
      uniform float uShineDamper;
      uniform float uReflectivity;
      
      void main() {
        vec3 unitNormal = normalize(tNormal);
        vec3 unitLightVector = normalize(tToLightVector);

        float dotComputation = dot(unitNormal, unitLightVector);
        float brightness = max(dotComputation, 0.4);
        vec3 diffuse = brightness * uLightColor;

        vec3 unitVectorToCamera = normalize(tToCameraVector);
        vec3 lightDirection = -unitLightVector;
        vec3 reflectedLightDirection = reflect(lightDirection, unitNormal);

        float specularFactor = dot(reflectedLightDirection, unitVectorToCamera);
        specularFactor = max(specularFactor, 0.0);
        float dampedFactor = pow(specularFactor, uShineDamper);
        vec3 finalSpecular = dampedFactor * uReflectivity * uLightColor;

        gl_FragColor = vec4(diffuse, 1.0) * texture(uTexture, tTexCoord) + vec4(finalSpecular, 1.0);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(TERRAIN_VERTEX, TERRAIN_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lNormal")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uModelMatrix")
      .addUniform("uViewMatrix")
      .addUniform("uProjectionMatrix")
      .addUniform("uLightPosition")
      .addUniform("uLightColor")
      .addUniform("uTexture")
      .addUniform("uShineDamper")
      .addUniform("uReflectivity")
      .unbind();
  }

  /**
   *
  **/
  GfxTerrainShader loadModelMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uModelMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadViewMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uViewMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadProjectionMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uProjectionMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadLightPosition(Vector3F position) {
    bind();
    loadUniform("uLightPosition", position);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadLightColor(Vector3F color) {
    bind();
    loadUniform("uLightColor", color);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadTexture(int id) {
    bind();
    loadUniform("uTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadShineDamper(float value) {
    bind();
    loadUniform("uShineDamper", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader loadReflectivity(float value) {
    bind();
    loadUniform("uReflectivity", value);
    unbind();
    return this;
  }
}