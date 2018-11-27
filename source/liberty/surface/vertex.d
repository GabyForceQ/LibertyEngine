/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.vertex;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.math.vector;

/**
 *
**/
struct SurfaceVertex {
  /**
   *
  **/
  Vector3F position;
  
  /**
   *
  **/
  Vector2F texCoord;

  /**
   *
  **/
  this(Vector3F position, Vector2F texCoord) {
    this.position = position;
    this.texCoord = texCoord;
  }

  /**
   *
  **/
  static void bindAttributePointer() {
    version (__OPENGL__) {
      glVertexAttribPointer(
        0,
        3,
        GL_FLOAT,
        GL_FALSE,
        SurfaceVertex.sizeof,
        cast(void*)SurfaceVertex.position.offsetof
      );

      glVertexAttribPointer(
        1,
        2,
        GL_FLOAT,
        GL_FALSE,
        SurfaceVertex.sizeof,
        cast(void*)SurfaceVertex.texCoord.offsetof
      );
    }
  }
}