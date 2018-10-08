/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/mesh.d, _mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.mesh;

import derelict.opengl : glDeleteVertexArrays, glDeleteBuffers;

import liberty.graphics.buffer : GfxBuffer;
import liberty.graphics.vao : GfxVAO;

/**
 *
**/
struct Mesh {
  /**
   *
  **/
  GfxVAO vao;

  /**
   *
  **/
  GfxBuffer vbo;
  
  /**
   *
  **/
  GfxBuffer ebo;

  /**
   *
  **/
  void clear() {
    vao.destroy();
    vbo.destroy();
    ebo.destroy();
  }
}