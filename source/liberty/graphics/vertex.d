/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vertex;

import liberty.core.math.vector : Vector2F, Vector3F;

/**
 *
**/
struct Vertex {
  /**
   *
  **/
  Vector3F position;

  /**
   *
  **/
  Vector3F normal;
  
  /**
   *
  **/
  Vector2F texCoord;

  /**
   *
  **/
  this(Vector3F position, Vector3F normal, Vector2F texCoord) {
    this.position = position;
    this.normal = normal;
    this.texCoord = texCoord;
  }
}