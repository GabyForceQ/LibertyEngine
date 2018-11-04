/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/camera/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.camera.constants;

package {
  immutable float YAW = -90.0f;
  immutable float PITCH = -30.0f;
  immutable float SPEED = 3.0f;
  immutable float SENSITIVITY = 0.1f;
  immutable float FOV = 45.0f;
}

/**
 *
**/
enum CameraMovement : ubyte {
  /**
   *
  **/
  FORWARD = 0x00,

  /**
   *
  **/
  BACKWARD = 0x01,
  
  /**
   *
  **/
  LEFT = 0x02,
  
  /**
   *
  **/
  RIGHT = 0x03,

  /**
   *
  **/
  UP = 0x04,

  /**
   *
  **/
  DOWN = 0x05
}