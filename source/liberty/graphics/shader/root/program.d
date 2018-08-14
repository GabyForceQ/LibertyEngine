/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/root/program.d, _program.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.root.program;

/**
 *
**/
abstract class ShaderProgram {
  protected {
    uint _programID;
    uint _vertexShaderID;
    uint _fragmentShaderID;
    int _attributeCount;
  }

  /**
   *
  **/
  this() {
    _programID = 0;
    _vertexShaderID = 0;
    _fragmentShaderID = 0;
    _attributeCount = 0;
  }
}