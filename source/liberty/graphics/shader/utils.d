/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/utils.d, _utils.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.utils;

///
import derelict.opengl;

///
import liberty.graphics;

pragma (inline, true) :
package(liberty.graphics):

///
GfxShaderProgram _createGfxShaderProgram(
  string vertexCode,
  string fragmentCode
) @trusted {
  // Create the new shader
  GfxShaderProgram res = new GLShaderProgram();
  
  // Compile created shader
  res.compileShaders(vertexCode, fragmentCode);

  // Add basic attributes
  res.bindAttribute("lPosition");
  res.bindAttribute("lTexCoord");
  
  // Link shaders
  res.linkShaders();
  
  return res;
}