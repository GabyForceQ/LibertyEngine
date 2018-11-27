/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/factory/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.factory.renderer;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.buffer.array;
import liberty.graphics.buffer.constants;
import liberty.graphics.buffer.impl;
import liberty.graphics.constants;

/**
 * Graphics renderer factory interface is implemented and used by models.
**/
interface IGfxRendererFactory {
  /**
   *
  **/
  static void drawElements(GfxDrawMode drawMode, GfxVectorType type, size_t count) {
    version (__OPENGL__) {
      GLenum _drawMode, _type;

      final switch (drawMode) with (GfxDrawMode) {
        case TRIANGLES: _drawMode = GL_TRIANGLES;
      }

      final switch (type) with (GfxVectorType) {
        case UINT: _type = GL_UNSIGNED_INT;
      }
      
      glDrawElements(_drawMode, cast(int)count, _type, null);
    }
  }

  /**
   *
  **/
  static void drawArrays(GfxDrawMode drawMode, size_t count) {
    version (__OPENGL__) {
      GLenum _drawMode;

      final switch (drawMode) with (GfxDrawMode) {
        case TRIANGLES: _drawMode = GL_TRIANGLES;
      }
      
      glDrawArrays(_drawMode, 0, cast(int)count);
    }
  }
}