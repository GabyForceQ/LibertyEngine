/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/skybox/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.skybox.shader;

import liberty.math.matrix;
import liberty.graphics.shader;

/**
 *
**/
class SkyboxShader : Shader {
  private {
    static immutable SKYBOX_VERTEX = SHADER_CORE_VERSION ~ q{
      layout (location = 0) in vec3 lPosition;

      out vec3 tTexCoord;

      uniform mat4 uProjectionMatrix;
      uniform mat4 uViewMatrix;

      void main() {
        tTexCoord = lTexCoord;

        gl_Position = uProjectionMatrix * uViewMatrix * vec4(lPosition, 1.0);
      }
    };

    static immutable SKYBOX_FRAGMENT = SHADER_CORE_VERSION ~ q{
      in vec2 tTexCoord;
      
      uniform sampler2D uCubeMap;

      void main() {
        gl_FragColor = texture(uCubeMap, tTexCoord);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(SKYBOX_VERTEX, SKYBOX_FRAGMENT)
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
  **/
  override SkyboxShader bind() {
    return cast(SkyboxShader)super.bind();
  }

  /**
   *
  **/
  override SkyboxShader unbind() {
    return cast(SkyboxShader)super.unbind();
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  SkyboxShader loadProjectionMatrix(Matrix4F matrix) {
    loadUniform("uProjectionMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  SkyboxShader loadViewMatrix(Matrix4F matrix) {
    loadUniform("uViewMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  SkyboxShader loadCubeMap(int id) {
    loadUniform("uCubeMap", id);
    return this;
  }
}