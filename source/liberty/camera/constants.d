/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/camera/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.camera.constants;

enum {
  /**
    * The default value of the camera yaw is -90.0f.
  **/
  CAMERA_DEFAULT_YAW = -90.0f,
  
  /**
    * The default value of the camera pitch is -30.0f.
  **/
  CAMERA_DEFAULT_PITCH = -30.0f,
  
  /**
    * The default value of the camera speed is 10.0f.
  **/
  CAMERA_DEFAULT_SPEED = 10.0f,
  
  /**
    * The default value of the camera mouse sensitivity is 0.1f.
  **/
  CAMERA_DEFAULT_SENSITIVITY = 0.1f,
  
  /**
    * The default value of the camera field of view is 45.0f.
  **/
  CAMERA_DEFAULT_FOV = 45.0f,
  
  /**
    * The default value of the camera zNear is 0.01f.
  **/
  CAMERA_DEFAULT_ZNEAR = 0.01f,
  
  /**
    * The default value of the camera zFar is 1000.0f.
  **/
  CAMERA_DEFAULT_ZFAR = 1000.0f
}

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