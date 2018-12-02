/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.constants;

version (Windows)
  /**
   * In Windows Nvidia/AMD, OpenGL 4.5 is used.
  **/
  enum GFX_SHADER_CORE_VERSION = "#version 450 core\n";
else version (linux)
  /**
   * In Linux IntelHDGraphics, OpenGL 3.0 is used.
  **/
  enum GFX_SHADER_CORE_VERSION = "#version 330 core\n";
else
  static assert(0, "Shader core not supported on this platform.");

/**
 * Shader program type.
**/
enum GfxShaderType : byte {
  /**
   * Vertex shader.
  **/
  VERTEX = 0x00,

  /**
   * Fragment shader.
  **/
  FRAGMENT = 0x01,

  /**
   * Geometry shader.
  **/
  GEOMETRY = 0x02
}

/**
 * Default shader graph type.
**/
enum GfxShaderGraphDefaultType : string {
  /**
   * Primitive shader type.
  **/
  PRIMITIVE = "Primitive",

  /**
   * Terrain shader type.
  **/
  TERRAIN = "Terrain",

  /**
   * SkyBox shader type.
  **/
  SKYBOX = "SkyBox"
}