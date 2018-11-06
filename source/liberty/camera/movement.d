/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/camera/movement.d)
 * Documentation:
 * Coverage:
**/
module liberty.camera.movement;

/**
 * Camera movement directions.
**/
enum CameraMovement : ubyte {
  /**
   * Camera is moving forward.
  **/
  FORWARD = 0x00,

  /**
   * Camera is moving backward.
  **/
  BACKWARD = 0x01,
  
  /**
   * Camera is moving left.
  **/
  LEFT = 0x02,
  
  /**
   * Camera is moving right.
  **/
  RIGHT = 0x03,

  /**
   * Camera is moving up.
  **/
  UP = 0x04,

  /**
   * Camera is moving down.
  **/
  DOWN = 0x05
}