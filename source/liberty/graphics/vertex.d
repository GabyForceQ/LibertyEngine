/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vertex.d, _vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vertex;

/**
 *
**/
align(4) struct Vertex2 {
  align(1) {
    /**
     *
    **/
    Position2D position;

    /**
     *
    **/
    Color color;

    /**
     *
    **/
    TexCoords texCoords;

    /**
     *
    **/
    void setColor(byte r, ubyte g, ubyte b, ubyte a) {
      color.r = r;
      color.g = g;
      color.b = b;
      color.a = a;
    }

    /**
     *
    **/
    void setTexCoords(float u, float v) {
      texCoords.u = u;
      texCoords.v = v;
    }
  }

  static assert (Vertex2.sizeof == 20LU); 
}

/**
 *
**/
struct Position2D {
  /**
   *
  **/
  float x;

  /**
   *
  **/
  float y;
}

/**
 *
**/
struct Color {
  /**
   *
  **/
  ubyte r;
  
  /**
   *
  **/
  ubyte g;
  
  /**
   *
  **/  
  ubyte b;

  /**
   *
  **/  
  ubyte a;
}

/**
 *
**/
struct TexCoords {
  /**
   *
  **/
  float u;
  
  /**
   *
  **/
  float v;
}