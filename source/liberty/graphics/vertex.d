/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vertex.d, _vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vertex;

import liberty.core.math.vector : Vector3F;

/**
 *
**/
struct Vertex3 {
  //static immutable int Size = 3;
  
  Vector3F position;

  //this(Vector3F position) {
  //  _position = position;
  //}
}

/**
 *
**/
align(4) struct Vertex2 {
  align(1) {
    /**
     *
    **/
    Position2 position;

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
    void setPosition(float x, float y) {
      position.x = x;
      position.y = y;
    }

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

    /**
     *
    **/
    string toString() {
      import std.conv : to;
      return "Position: " ~ position.toString() ~ "; " ~
        "Color: " ~ color.toString() ~ "; " ~
        "TexCoords: " ~ texCoords.toString();
    }
  }

  static assert (Vertex2.sizeof == 20LU); 
}

/**
 *
**/
struct Position2 {
  /**
   *
  **/
  float x;

  /**
   *
  **/
  float y;

  /**
   *
  **/
  string toString() {
    import std.conv : to;
    return "[x: " ~ x.to!string ~ "; y: " ~ y.to!string ~ "]";
  }
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

  /**
   *
  **/
  string toString() {
    import std.conv : to;
    return "[r: " ~ r.to!string ~ "; g: " ~ g.to!string ~
      "; b: " ~ b.to!string ~ "; a: " ~ a.to!string ~ "]";
  }
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

  /**
   *
  **/
  string toString() {
    import std.conv : to;
    return "[u: " ~ u.to!string ~ "; v: " ~ v.to!string ~ "]";
  }
}