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
 * Possible video card vendors.
**/
enum GfxVendor : byte {
  /**
   * AMD vendor.
  **/
  AMD = 0x00,

  /**
   * Intel vendor.
  **/
  INTEL = 0x01,

  /**
   * Nvidia vendor.
  **/
  NVIDIA = 0x02,

  /**
   * Vendor is unknown.
  **/
  UNKNOWN = -0x01
}

/**
 *
**/
enum GfxBlending : byte {
  /**
   *
  **/
	OPAQUE = 0x00,
  
	/**
   *
  **/
	ALPHA_BLEND = 0x01,
  
	/**
   *
  **/
	NON_PREMULTIPLIED = 0x02,
 
  /**
   *
  **/
	ADDITIVE = 0x03
}

/**
 *
**/
enum GfxSampling : byte {
  /**
   *
  **/
	ANISOTROPIC_CLAMP = 0x00,
  
	/**
   *
  **/
	ANISOTROPIC_WRAP = 0x01,
  
	/**
   *
  **/
	LINEAR_CLAMP = 0x02,
  
	/**
   *
  **/
	LINEAR_WRAP = 0x03,
  
	/**
   *
  **/
	POINT_CLAMP = 0x04,
  
	/**
   *
  **/
	POINT_WRAP = 0x05
}

/**
 *
**/
enum GfxVSyncState : byte {
  /**
   *
  **/
	IMMEDIATE = 0x00,
  
	/**
   *
  **/
	DEFAULT = 0x01,
  
	/**
   *
  **/
	LATE_TEARING = -0x01
}

/**
 * Draw modes.
**/
enum GfxDrawMode : byte {
  /**
   * Draw triangles.
  **/
	TRIANGLES = 0x00
}

/**
 *
**/
enum GfxVectorType : byte {
  /**
   * Unsigned integer.
  **/
	UINT = 0x00
}