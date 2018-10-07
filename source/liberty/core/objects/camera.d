/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/camera.d, _camera.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.camera;

import liberty.core.input : Input, KeyCode;
import liberty.core.math.functions : radians, sin, cos;
import liberty.core.math.vector : Vector2I, Vector3F, cross;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.platform : Platform;
import liberty.core.engine : CoreEngine;
import liberty.core.time : Time;
import liberty.core.objects.node : WorldObject;
import liberty.core.objects.meta : NodeBody;

private {
  immutable float YAW = -90.0f;
  immutable float PITCH = 0.0f;
  immutable float SPEED = 2.5f;
  immutable float SENSITIVITY = 0.1f;
  immutable float FOV = 45.0f;
}

/**
 *
**/
final class Camera : WorldObject {
  mixin(NodeBody);

  private {
    Vector3F positionVector = Vector3F(0.0f, 0.0f, 3.0f);
    Vector3F frontVector = Vector3F.backward;
    Vector3F upVector = Vector3F.up;
    Vector3F rightVector = Vector3F.zero;
    Vector3F worldUpVector = Vector3F.up;

    float yaw = YAW;
    float pitch = PITCH;

    float movementSpeed = SPEED;
    float mouseSensitivity = SENSITIVITY;
    float fieldOfView = FOV;

    bool inputLocked;
  }

  /**
   *
  **/
  void constructor() {
    updateCameraVectors();
  }

  /**
   *
  **/
  Vector3F getFrontVector() {
    return frontVector;
  }

  /**
   *
  **/
  void lockInput() pure nothrow {
    inputLocked = true;
  }

  /**
   *
  **/
  void unlockInput() pure nothrow {
    inputLocked = false;
  }

  /**
   *
  **/
  bool isInputLocked() pure nothrow const {
    return inputLocked;
  }

  /**
   *
  **/
  void processKeyboard(CameraMovement direction) {
    if (!inputLocked) {
      const float velocity = movementSpeed * Time.getDelta();

      final switch (direction) with (CameraMovement) {
        case FORWARD:
          positionVector += frontVector * velocity;
          break;
        
        case BACKWARD:
          positionVector -= frontVector * velocity;
          break;

        case LEFT:
          positionVector -= rightVector * velocity;
          break;

        case RIGHT:
          positionVector += rightVector * velocity;
          break;
      }
    }
  }

  /**
   *
  **/
  void processMouseMovement(float xOffset, float yOffset, bool constrainPitch = true) {
    if (!inputLocked) {
      xOffset *= mouseSensitivity;
      yOffset *= mouseSensitivity;

      yaw += xOffset;
      pitch += yOffset;

      if (constrainPitch) {
        if (pitch > 89.0f)
          pitch = 89.0f;
        if (pitch < -89.0f)
          pitch = -89.0f;
      }

      updateCameraVectors();
    }
  }

  /**
   *
  **/
  void processMouseScroll(float yOffset) {
    if (!inputLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= FOV)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= FOV)
        fieldOfView = FOV;
    }
  }

  /**
   *
  **/
  Matrix4F getViewMatrix() {
    return Matrix4F.lookAt(
      positionVector,
      positionVector + frontVector,
      upVector
    );
  }

  /**
   *
  **/
  Matrix4F getProjectionMatrix() {
    return Matrix4F.perspective(
      fieldOfView.radians,
      cast(float)Platform.getWindow().getFrameBufferWidth(),
      cast(float)Platform.getWindow().getFrameBufferHeight(),
      0.1f,
      1000.0f
    );
  }

  /**
   *
  **/
  Vector3F getPosition() pure nothrow {
    return positionVector;
  }

  /**
   *
  **/
  float getFieldOfView() pure nothrow const {
    return fieldOfView;
  }

  private void updateCameraVectors() {
    Vector3F front;
    front.x = cos(radians(yaw)) * cos(radians(pitch));
    front.y = sin(radians(pitch));
    front.z = sin(radians(yaw)) * cos(radians(pitch));
    frontVector = front.normalized();

    rightVector = cross(frontVector, worldUpVector).normalized();
    upVector = cross(rightVector, frontVector).normalized();
  }
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
  RIGHT = 0x03
}