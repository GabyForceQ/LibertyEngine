/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.vertex;

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
}