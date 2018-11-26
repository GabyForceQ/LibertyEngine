/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.constants;

/**
 * All system types.
**/
enum SystemType : string {
  /**
   * See $(D PrimitiveSystem) class.
  **/
  Primitive = "Primitive",

  /**
   * See $(D TerrainSystem) class.
  **/
  Terrain = "Terrain",

  /**
   * See $(D SurfaceSystem) class.
  **/
  Surface = "Surface",

  /**
   * See $(D LightingSystem) class.
  **/
  Lighting = "Lighting",

  /**
   * See $(D CubeMapSystem) class.
  **/
  CubeMap = "CubeMap",

  /**
   * See $(D TextSystem) class.
  **/
  Text = "Text"
}

/**
 * Visibility state for an element.
**/
enum Visibility : byte {
  /**
   * The element is rendering.
   * Its physics is processing.
  **/
  Visible = 0x00,

  /**
   * The element is not rendering.
   * Its physics is processing.
  **/
  Hidden = 0x01,

  /**
   * The element is not rendering.
   * Its physics is not processing.
  **/
  Collapsed = 0x02
}