/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/generic.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.generic;

import std.conv : to;

import liberty.core.math.matrix : Matrix4F;
import liberty.core.math.vector : Vector3F;
import liberty.graphics.shader.impl : GfxShader;

/**
 *
**/
class GfxGenericShader : GfxShader {
  private {
    static immutable GENERIC_VERTEX = q{
      #version 330 core

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
      uniform float uUseFakeLighting;

      const float density = 0.01;
      const float gradient = 1.5;

      void main() {
        // Compute fake lighting if necessary
        vec3 actualNormal = lNormal;
        if (uUseFakeLighting > 0.5)
          actualNormal = vec3(0.0, 1.0, 0.0);
        
        tTexCoord = lTexCoord;// vec2(lTexCoord.x, -lTexCoord.y);
        tNormal = (uModelMatrix * vec4(actualNormal, 0.0)).xyz;

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

    static immutable GENERIC_FRAGMENT = q{
      #version 330 core

      in vec3 tNormal;
      in vec2 tTexCoord;
      in vec3 tToLightVector[4];
      in vec3 tToCameraVector;
      in float tVisibility;

      uniform sampler2D uTexture;
      uniform vec3 uLightColor[4];
      uniform float uShineDamper;
      uniform float uReflectivity;
      uniform vec3 uSkyColor;
      
      void main() {
        vec3 unitNormal = normalize(tNormal);
        vec3 unitVectorToCamera = normalize(tToCameraVector);

        vec3 totalDiffuse = vec3(0.0);
        vec3 totalSpecular = vec3(0.0);

        for (int i = 0; i < 4; i++) {
          vec3 unitLightVector = normalize(tToLightVector[i]);
          float dotComputation = dot(unitNormal, unitLightVector);
          float brightness = max(dotComputation, 0.0);
          vec3 lightDirection = -unitLightVector;
          vec3 reflectedLightDirection = reflect(lightDirection, unitNormal);
          float specularFactor = dot(reflectedLightDirection, unitVectorToCamera);
          specularFactor = max(specularFactor, 0.0);
          float dampedFactor = pow(specularFactor, uShineDamper);
          totalDiffuse += brightness * uLightColor[i];
          totalSpecular += dampedFactor * uReflectivity * uLightColor[i];
        }

        totalDiffuse = max(totalDiffuse, 0.4);

        // Compute alpha channel of final texture if necessary
        vec4 finalTexture = texture(uTexture, tTexCoord);
        if (finalTexture.a < 0.5)
          discard;

        // Mix sky color with finalTexture
        gl_FragColor = mix(vec4(uSkyColor, 1.0), vec4(totalDiffuse, 1.0) * finalTexture + vec4(totalSpecular, 1.0), tVisibility);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(GENERIC_VERTEX, GENERIC_FRAGMENT)
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
      .addUniform("uTexture")
      .addUniform("uShineDamper")
      .addUniform("uReflectivity")
      .addUniform("uUseFakeLighting")
      .addUniform("uSkyColor")
      .unbind();
  }

  /**
   *
  **/
  GfxGenericShader loadModelMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uModelMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadViewMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uViewMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadProjectionMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uProjectionMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadLightPosition(uint index, Vector3F position) {
    bind();
    loadUniform("uLightPosition[" ~ index.to!string ~ "]", position);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadLightColor(uint index, Vector3F color) {
    bind();
    loadUniform("uLightColor[" ~ index.to!string ~ "]", color);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadTexture(int id) {
    bind();
    loadUniform("uTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadShineDamper(float value) {
    bind();
    loadUniform("uShineDamper", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadReflectivity(float value) {
    bind();
    loadUniform("uReflectivity", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadUseFakeLighting(bool value) {
    bind();
    loadUniform("uUseFakeLighting", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  GfxGenericShader loadSkyColor(Vector3F color) {
    bind();
    loadUniform("uSkyColor", color);
    unbind();
    return this;
  }
}