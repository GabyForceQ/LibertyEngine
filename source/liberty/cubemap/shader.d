/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.shader;

import liberty.math.matrix;
import liberty.graphics.shader;

/**
 *
**/
final class CubeMapShader : Shader {
  private {
    static immutable CUBEMAP_VERTEX = SHADER_CORE_VERSION ~ q{
      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec3 lTexCoord;

      out vec3 tTexCoord;

      uniform mat4 uProjectionMatrix;
      uniform mat4 uViewMatrix;

      void main() {
        tTexCoord = lTexCoord;

        gl_Position = uProjectionMatrix * uViewMatrix * vec4(lPosition, 1.0);
      }
    };

    static immutable CUBEMAP_FRAGMENT = SHADER_CORE_VERSION ~ q{
      in vec3 tTexCoord;
      
      uniform samplerCube uCubeMap;

      void main() {
        gl_FragColor = texture(uCubeMap, tTexCoord);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(CUBEMAP_VERTEX, CUBEMAP_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bind()
      .addUniform("uProjectionMatrix")
      .addUniform("uViewMatrix")
      .addUniform("uCubeMap")
      .unbind();
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
}