/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vertex/meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vertex.meta;

version (__OPENGL__)
  import bindbc.opengl;

/**
 *
**/
mixin template GfxVertexSpec() {
  /**
   *
  **/
  static void bindAttributePointer() {
    static vec(N)(N n) { 
      return "Vector!(float, cast(ubyte)" ~ n ~ "u)";
    }
    
    static foreach (i, member; __traits(allMembers, typeof(this)))
      static foreach (j, type; [vec("2"), vec("3"), vec("4")])
        static if (typeof(__traits(getMember, typeof(this), member)).stringof == type)
          mixin("IGfxVertexFactory.bindAttributePointer!" ~ typeof(this).stringof
            ~ "(i - 1, j + 2, cast(void*)" ~ typeof(this).stringof ~ "." ~ member ~ ".offsetof);");
  }
}

/**
 *
**/
interface IGfxVertexFactory {
  /**
   *
  **/
  static void bindAttributePointer(VERTEX)(int i, int j, void* offset) {
    version (__OPENGL__)
      glVertexAttribPointer(i, j, GL_FLOAT, GL_FALSE, VERTEX.sizeof, offset);
  }
}