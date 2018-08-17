/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vao/gfx.d, _gfx.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vao.gfx;

/**
 * Vertex Array Object.
**/
package(liberty.graphics) abstract class GfxVertexArrayObject {
	protected {
    uint _handle;
    bool _initialized;
  }

  /**
   * Use this Vertex Array Object.
  **/
  void bind() @trusted;

  /**
   * Unuse this Vertex Array Object.
  **/
  void unbind() @trusted;
  
  /**
   * Returns resource handle.
  **/
  uint getHandle() pure nothrow const @safe;
}