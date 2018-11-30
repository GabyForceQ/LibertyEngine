/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.renderer;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.logger.impl;
import liberty.graphics.texture.constants;
import liberty.model.impl;

/**
 * Shader renderer abstract class is inherited by shader objects.
 * See $(D GfxShader) class.
**/
abstract class GfxShaderRenderer {
  protected {
    int attributeCount;
  }

  /**
   * Returns the number of attributes used by the shader.
  **/
  int getAttributeCount() pure nothrow const {
    return attributeCount;
  }

  /**
   * Enable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R enableVertexAttributeArray(this R)(int vaoID) {
    glBindVertexArray(vaoID);

    foreach (i; 0..attributeCount)
      glEnableVertexAttribArray(i);

    return cast(R)this;
  }

  /**
   * Disable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R disableVertexAttributeArray(this R)() {
    foreach (i; 0..attributeCount)
      glDisableVertexAttribArray(i);
    
    glBindVertexArray(0);

    return cast(R)this;
  }

  /**
   * Step1: Enable vertex attribute array for the model.
   * Step2: Render a model to the screen by calling render method from model.
   * Step3: Disable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R render(this R)(Model model) {
    enableVertexAttributeArray(model.getRawModel.vaoID);

    loop0: foreach (i; 0..model.getMaterials.length) {
      switch (i) {
        case 0: glActiveTexture(GL_TEXTURE0); break;
        case 1: glActiveTexture(GL_TEXTURE1); break;
        case 2: glActiveTexture(GL_TEXTURE2); break;
        case 3: glActiveTexture(GL_TEXTURE3); break;
        case 4: glActiveTexture(GL_TEXTURE4); break;
        default: break loop0;
      }

      const texture = model.getMaterials[i].getTexture;
      final switch (texture.getType) with (TextureType) {
        case NONE: Logger.error("Cannot bind none texture.", typeof(this).stringof); break;
        case TEX_2D: glBindTexture(GL_TEXTURE_2D, texture.getId); break;
        case CUBE_MAP: glBindTexture(GL_TEXTURE_CUBE_MAP, texture.getId); break;
      }
    }

    model.render();

    loop1: foreach (i; 0..model.getMaterials.length) {
      switch (i) {
        case 0: glActiveTexture(GL_TEXTURE0); break;
        case 1: glActiveTexture(GL_TEXTURE1); break;
        case 2: glActiveTexture(GL_TEXTURE2); break;
        case 3: glActiveTexture(GL_TEXTURE3); break;
        case 4: glActiveTexture(GL_TEXTURE4); break;
        default: break loop1;
      }

      const texture = model.getMaterials[i].getTexture;
      final switch (texture.getType) with (TextureType) {
        case NONE: Logger.error("Cannot unbind none texture.", typeof(this).stringof); break;
        case TEX_2D: glBindTexture(GL_TEXTURE_2D, 0); break;
        case CUBE_MAP: glBindTexture(GL_TEXTURE_CUBE_MAP, 0); break;
      }
    }

    disableVertexAttributeArray();

    return cast(R)this;
  }
}