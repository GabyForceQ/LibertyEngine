/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.shader;

import liberty.math.vector;
import liberty.graphics.shader;

/**
 *
**/
final class TextShader : GfxShaderProgram {
  private {
    static immutable FONT_VERTEX = GFX_SHADER_CORE_VERSION ~ q{
      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec2 lTexCoord;

      out vec2 tTexCoord;

      uniform vec2 uTranslation;

      void main() {
        tTexCoord = lTexCoord;

        gl_Position = vec4(lPosition + vec3(uTranslation.x, uTranslation.y, 1.0)
          * vec3(2.0, -2.0, 1.0), 1.0);
      }
    };

    static immutable FONT_FRAGMENT = GFX_SHADER_CORE_VERSION ~ q{
      in vec2 tTexCoord;

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
    this
      .compileShaders(FONT_VERTEX, FONT_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uTranslation")
      .addUniform("uColor")
      .addUniform("uFontAtlas")
      .loadFontAtlas(0)
      .unbind();
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadTranslation(Vector2F matrix) {
    super.loadUniform("uTranslation", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadColor(Vector3F matrix) {
    super.loadUniform("uColor", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadFontAtlas(int id) {
    super.loadUniform("uFontAtlas", id);
    return this;
  }
}