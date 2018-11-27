/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.vertex;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.math.vector;

/**
 *
**/
struct TerrainVertex {
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

  /**
   *
  **/
  static void bindAttributePointer() {
    glVertexAttribPointer(
      0,
      3,
      GL_FLOAT,
      GL_FALSE,
      TerrainVertex.sizeof,
      cast(void*)TerrainVertex.position.offsetof
    );
    
    glVertexAttribPointer(
      1,
      3,
      GL_FLOAT,
      GL_FALSE,
      TerrainVertex.sizeof,
      cast(void*)TerrainVertex.normal.offsetof
    );
    
    glVertexAttribPointer(
      2,
      2,
      GL_FLOAT,
      GL_FALSE,
      TerrainVertex.sizeof,
      cast(void*)TerrainVertex.texCoord.offsetof
    );
  }
}