/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/model.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.model;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.model;
import liberty.core.engine;
import liberty.material.impl;
import liberty.model.io;
import liberty.graphics.engine;
import liberty.surface.vertex;

/**
 *
**/
final class SurfaceModel : Model {  
  /**
   *
  **/
  this(RawModel rawModel, Material[] materials) {
    super(rawModel, materials);
  }

  /**
   *
  **/
  override void render() {
    GfxEngine.enableAlphaBlend();
    
    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());
    }

    super.render();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    GfxEngine.disableBlend();
  }
}