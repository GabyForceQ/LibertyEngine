/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/objects/camera/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.objects.camera.constants;

/**
 * Default yaw value.
 * It cannot be modified during the runtime.
**/
enum float Yaw = -90.0f;

/**
 * Default pitch value.
 * It cannot be modified during the runtime.
**/
enum float Pitch = 0.0f;

/**
 *
**/
enum CameraProjection: ubyte {
  /**
   * For 3D and 2D views.
  **/
  Perspective = 0x00,

  /**
   * Only for 2D views.
  **/
  Orthographic = 0x01
}

/**
 *
**/
enum CameraMovement: ubyte {
  /**
   *
  **/
  Forward = 0x00,
  
  /**
   *
  **/
  Backward = 0x01,
  
  /**
   *
  **/
  Left = 0x02,
  
  /**
   *
  **/
  Right = 0x03
}