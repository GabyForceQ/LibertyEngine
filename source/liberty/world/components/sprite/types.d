/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/components/sprite/types.d, _types.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.components.sprite.types;

import liberty.graphics.vertex : Vertex2;

/**
 *
**/
struct SpriteGlyph {
  /**
   *
  **/
  uint texture;
  
  /**
   *
  **/
  float depth;

  /**
   *
  **/
  Vertex2 topLeft;

  /**
   *
  **/
  Vertex2 bottomLeft;

  /**
   *
  **/
  Vertex2 topRight;
  
  /**
   *
  **/
  Vertex2 bottomRight;

  /**
   *
  **/
  string toString() {
    import std.conv : to;
    return "Texture: " ~ texture.to!string ~ "\n" ~
      "Depth: " ~ depth.to!string ~ "\n" ~
      "TopLeft: " ~ topLeft.toString() ~ "\n" ~
      "BottomLeft: " ~ bottomLeft.toString() ~ "\n" ~
      "TopRight: " ~ topRight.toString() ~ "\n" ~
      "BottomRight: " ~ bottomRight.toString() ~ "\n";
  }
}

/**
 *
**/
struct RenderBatch {
  /**
   *
  **/
  uint offset;

  /**
   *
  **/
  uint vertexCount;
  
  /**
   *
  **/
  uint texture;

  /**
   *
  **/
  this(uint offset, uint vertexCount, uint texture) {
    this.offset = offset;
    this.vertexCount = vertexCount;
    this.texture = texture;
  }
}