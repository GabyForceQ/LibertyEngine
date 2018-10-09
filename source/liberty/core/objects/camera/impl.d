/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/camera/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.camera.impl;

import liberty.core.math.functions : radians, sin, cos;
import liberty.core.math.vector : Vector2I, Vector3F, cross;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.platform : Platform;
import liberty.core.time : Time;
import liberty.core.objects.camera.constants;
import liberty.core.objects.camera.preset : CameraPreset;
import liberty.core.objects.meta : NodeBody;
import liberty.core.objects.node : WorldObject;

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

    CameraPreset preset;

    bool mouseMoveLocked;
    bool mouseScrollLocked;
    bool keyboardLocked;
  }

  /**
   * Camera custom constructor.
   * Calls: $(D, updateCameraVectors).
   * It adds default $(D, CameraPreset).
  **/
  void constructor() {
    updateCameraVectors();

    preset = CameraPreset.getDefault();
  }

  /**
   * Keyboard listener.
   * Works only if camera input listener isn't locked.
  **/
  void processKeyboard(CameraMovement direction) {
    if (!keyboardLocked) {
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

        case UP:
          positionVector += upVector * velocity;
          break;

        case DOWN:
          positionVector -= upVector * velocity;
      }
    }
  }

  /**
   * Mouse move listener.
   * Works only if camera input listener isn't locked.
  **/
  void processMouseMovement(float xOffset, float yOffset, bool constrainPitch = true) {
    if (!mouseMoveLocked) {
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
   * Mouse scroll listener.
   * Works only if camera input listener isn't locked.
  **/
  void processMouseScroll(float yOffset) {
    if (!mouseScrollLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= FOV)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= FOV)
        fieldOfView = FOV;
    }
  }

  /**
   * Returns: camera view matrix.
  **/
  Matrix4F getViewMatrix() {
    return Matrix4F.lookAt(
      positionVector,
      positionVector + frontVector,
      upVector
    );
  }

  /**
   * Returns: camera projection matrix.
  **/
  Matrix4F getProjectionMatrix() nothrow {
    return Matrix4F.perspective(
      fieldOfView.radians,
      cast(float)Platform.getWindow().getFrameBufferWidth(),
      cast(float)Platform.getWindow().getFrameBufferHeight(),
      0.01f,
      1000.0f
    );
  }

  /**
   * Set camera position.
  **/
  void setPosition(Vector3F positionVector) pure nothrow {
    this.positionVector = positionVector;
  }

  /**
   * Returns: camera position.
  **/
  Vector3F getPosition() pure nothrow const {
    return positionVector;
  }

  /**
   * Returns: camera front vector.
  **/
  Vector3F getFrontVector() pure nothrow {
    return frontVector;
  }

  /**
   * Returns: camera up vector.
  **/
  Vector3F getUpVector() pure nothrow const {
    return upVector;
  }

  /**
   * Returns: camera right vector.
  **/
  Vector3F getRightVector() pure nothrow {
    return rightVector;
  }

  /**
   * Returns: camera world up vector.
  **/
  Vector3F getWorldUpVector() pure nothrow const {
    return worldUpVector;
  }

  /**
   * Set camera yaw.
  **/
  void setYaw(float yaw) pure nothrow {
    this.yaw = yaw;
  }

  /**
   * Returns: camera yaw.
  **/
  float getCameraYaw() pure nothrow const {
    return yaw;
  }

  /**
   * Set camera pitch.
  **/
  void setPitch(float pitch) pure nothrow {
    this.pitch = pitch;
  }

  /**
   * Returns: camera pitch.
  **/
  float getCameraPitch() pure nothrow const {
    return pitch;
  }

  /**
   * Set camera movement speed.
  **/
  void setMovementSpeed(float movementSpeed) pure nothrow {
    this.movementSpeed = movementSpeed;
  }

  /**
   * Returns: camera movement speed.
  **/
  float getMovementSpeed() pure nothrow const {
    return movementSpeed;
  }

  /**
   * Set camera mouse sensitivity.
  **/
  void setMouseSensitivity(float mouseSensitivity) pure nothrow {
    this.mouseSensitivity = mouseSensitivity;
  }

  /**
   * Returns: camera mouse sensitivity.
  **/
  float getMouseSensitivity() pure nothrow const {
    return mouseSensitivity;
  }

  /**
   * Set camera field of view.
  **/
  void setFieldOfView(float fieldOfView) pure nothrow {
    this.fieldOfView = fieldOfView;
  }

  /**
   * Returns: camera field of view.
  **/
  float getFieldOfView() pure nothrow const {
    return fieldOfView;
  }

  /**
   *
  **/
  void setPreset(CameraPreset preset) pure nothrow {
    this.preset = preset;
  }

  /**
   * Returns: current camera preset.
  **/
  CameraPreset getPreset() pure nothrow {
    return preset;
  }

  /**
   * Lock camera mouse move listener.
  **/
  void lockMouseMove() pure nothrow {
    mouseMoveLocked = true;
  }

  /**
   * Unlock camera mouse move listener.
  **/
  void unlockMouseMove() pure nothrow {
    mouseMoveLocked = false;
  }

  /**
   * Returns: true if mouse move listener is locked.
  **/
  bool isMouseMoveLocked() pure nothrow const {
    return mouseMoveLocked;
  }

  /**
   * Lock camera mouse scroll listener.
  **/
  void lockMouseScroll() pure nothrow {
    mouseScrollLocked = true;
  }

  /**
   * Unlock camera mouse scroll listener.
  **/
  void unlockMouseScroll() pure nothrow {
    mouseScrollLocked = false;
  }

  /**
   * Returns: true if mouse scroll listener is locked.
  **/
  bool isMouseScrollLocked() pure nothrow const {
    return mouseScrollLocked;
  }

  /**
   * Lock camera keyboard listener.
  **/
  void lockKeyboard() pure nothrow {
    keyboardLocked = true;
  }

  /**
   * Unlock camera keyboard listener.
  **/
  void unlockKeyboard() pure nothrow {
    keyboardLocked = false;
  }

  /**
   * Returns: true if keyboard listener is locked.
  **/
  bool isKeyboardLocked() pure nothrow const {
    return keyboardLocked;
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