/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vao/utils.d, _utils.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vao.utils;

///
import derelict.opengl;

///
import liberty.graphics;

pragma (inline, true) :
package(liberty.graphics):

GfxVertexArrayObject _createGfxVertexArrayObject() @safe {
  GfxVertexArrayObject vao = null;
  vao = new GLVertexArrayObject();
  return vao;
}