/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.shader;

import liberty.graphics.shader;
import liberty.math.matrix;
import liberty.math.vector;

/**
 *
**/
final class CubeMapShader : GfxShader {
  private {
    static immutable CUBEMAP_VERTEX = GFX_SHADER_CORE_VERSION ~ q{
      layout (location = 0) in vec3 lPosition;

      out vec3 tTexCoord;

      uniform mat4 uProjectionMatrix;
      uniform mat4 uViewMatrix;

      void main() {
        tTexCoord = vec3(lPosition.x, -1.0 * lPosition.y, lPosition.z);

        gl_Position = uProjectionMatrix * uViewMatrix * vec4(lPosition, 1.0);
      }
    };

    static immutable CUBEMAP_FRAGMENT = GFX_SHADER_CORE_VERSION ~ q{
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
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(CUBEMAP_VERTEX, CUBEMAP_FRAGMENT);
    linkShaders();
    bindAttribute("lPosition");
    this.bind();
    addUniform("uProjectionMatrix");
    addUniform("uViewMatrix");
    addUniform("uCubeMap");
    addUniform("uFogColor");
    addUniform("uFadeLowerLimit");
    addUniform("uFadeUpperLimit");
    loadCubeMap(0);
    this.unbind();
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadProjectionMatrix(Matrix4F matrix) {
    loadUniform("uProjectionMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadViewMatrix(Matrix4F matrix) {
    loadUniform("uViewMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadCubeMap(int id) {
    loadUniform("uCubeMap", id);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadFogColor(Vector3F vector) {
    loadUniform("uFogColor", vector);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadFadeLowerLimit(float value) {
    loadUniform("uFadeLowerLimit", value);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadFadeUpperLimit(float value) {
    loadUniform("uFadeUpperLimit", value);
    return this;
  }
}