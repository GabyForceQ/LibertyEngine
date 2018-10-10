/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.constants;

/**
 *
**/
enum GfxVendor : byte {
  /**
   *
  **/
  Amd = 0x00,

  /**
   *
  **/
  Intel = 0x01,

  /**
   *
  **/
  Nvidia = 0x02,

  /**
   *
  **/
  Other = -0x01
}

/**
 *
**/
enum GfxBlending : byte {
  /**
   *
  **/
	Opaque = 0x00,
  
	/**
   *
  **/
	AlphaBlend = 0x01,
  
	/**
   *
  **/
	NonPremultiplied = 0x02,
 
  /**
   *
  **/
	Additive = 0x03
}

/**
 *
**/
enum GfxSampling : byte {
  /**
   *
  **/
	AnisotropicClamp = 0x00,
  
	/**
   *
  **/
	AnisotropicWrap = 0x01,
  
	/**
   *
  **/
	LinearClamp = 0x02,
  
	/**
   *
  **/
	LinearWrap = 0x03,
  
	/**
   *
  **/
	PointClamp = 0x04,
  
	/**
   *
  **/
	PointWrap = 0x05
}

/**
 *
**/
enum GfxVSyncState : byte {
  /**
   *
  **/
	Immediate = 0x00,
  
	/**
   *
  **/
	Default = 0x01,
  
	/**
   *
  **/
	LateTearing = -0x01
}

/**
 *
**/
enum GfxDrawMode : byte {
  /**
   *
  **/
	Triangles = 0x00
}

/**
 *
**/
enum GfxVectorType : byte {
  /**
   *
  **/
	UnsignedInt = 0x00
}