/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/ui.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.ui;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.graphics.shader.impl : GfxShader;

/**
 *
**/
class GfxUIShader : GfxShader {
  private {
    static immutable UI_VERTEX = q{
      #version 450 core

      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec2 lTexCoord;

      out vec2 tTexCoord;

      //uniform mat4 uTransformationMatrix;

      void main() {
        tTexCoord = vec2((lPosition.x + 1.0) / 2.0, 1.0 - (lPosition.y + 1.0) / 2.0);

        gl_Position = vec4(lPosition, 1.0);
      }
    };

    static immutable UI_FRAGMENT = q{
      #version 450 core

      in vec2 tTexCoord;
      
      uniform sampler2D uTexture;

      void main() {
        gl_FragColor = texture(uTexture, tTexCoord);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(UI_VERTEX, UI_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uTexture")
      .unbind();
  }

  /**
   *
  **/
  GfxUIShader loadTexture(int id) {
    bind();
    loadUniform("uTexture", id);
    unbind();
    return this;
  }
}