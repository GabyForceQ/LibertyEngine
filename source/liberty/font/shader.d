/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.shader;

import liberty.math.vector;
import liberty.graphics.shader;

/**
 *
**/
class FontShader : Shader {
  private {
    static immutable FONT_VERTEX = q{
      #version 450 core

      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec2 lTexCoord;

      out vec2 tTexCoord;

      uniform vec2 uTranslation;

      void main() {
        tTexCoord = lTexCoord;

        gl_Position = vec4(lPosition + vec3(uTranslation) * vec3(2.0, -2.0, 1.0), 1.0);
      }
    };

    static immutable FONT_FRAGMENT = q{
      #version 450 core

      out vec2 tTexCoord;

      uniform vec3 uColor;
      uniform sampler2D uFontAtlas;

      void main() {
        gl_FragColor = vec4(uColor, texture(uFontAtlas, tTexCoord).a);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(FONT_VERTEX, FONT_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uTranslation")
      .addUniform("uColor")
      .addUniform("uFontAtlas")
      .unbind();
  }

  /**
   *
  **/
  override FontShader bind() {
    return cast(FontShader)super.bind();
  }

  /**
   *
  **/
  override FontShader unbind() {
    return cast(FontShader)super.unbind();
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  FontShader loadTranslation(Vector2F matrix) {
    loadUniform("uTranslation", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  FontShader loadColor(Vector3F matrix) {
    loadUniform("uColor", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  FontShader loadFontAtlas(int id) {
    loadUniform("uFontAtlas", id);
    return this;
  }
}