/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/camera/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.camera.impl;

import liberty.core.engine;
import liberty.math.functions;
import liberty.math.transform;
import liberty.math.vector;
import liberty.math.matrix;
import liberty.core.platform;
import liberty.time;
import liberty.camera.constants;
import liberty.camera.preset;
import liberty.scene.meta;
import liberty.scene.entity;
import liberty.scene.impl;

/**
 * Represents the view of the observer.
 * Everything that is rendered to the screen is processed within the projection matrix and view matrix of a camera.
 * Inheriths $(D Entity) class and encapsulates $(D NodeBody) macro.
 * It has a custom constructor that calls: $(D updateCameraVectors) and adds default $(D CameraPreset).
**/
final class Camera : Entity {
  mixin NodeBody;

  private {
    float _yaw = -90.0f;
    float _pitch = -30.0f;
    float _zNear = 0.01f;
    float _zFar = 1000.0f;
  }

  ///
  Vector3F frontVector = Vector3F.forward;
  ///
  Vector3F upVector = Vector3F.up;
  ///
  Vector3F rightVector = Vector3F.zero;
  ///
  Vector3F worldUpVector = Vector3F.up;
  ///
  float mouseSensitivity = 0.1f;
  ///
  float fieldOfView = 45.0f;
  ///
  float movementSpeed = 10.0f;
  ///
  bool mouseMoveLocked;
  ///
  bool mouseScrollLocked;
  ///
  bool keyboardLocked;
  ///
  bool constrainPitch = true;
  ///
  CameraPreset preset;

  /// Default camera constructor.
  this(string id) {
    super(id);
    register;

    updateCameraVectors;
    preset = CameraPreset.getDefault;
    
    component!Transform
      .setLocation(0.0f, 3.0f, 4.0f);
  }

  /// Get camera yaw.
  @property float yaw() { return _yaw; }

  /// Get camera pitch.
  @property float pitch() { return _pitch; }

  /// Get camera zNear.
  @property float zNear() { return _zNear; }

  /// Get camera zFar.
  @property float zFar() { return _zFar; }

  /// Set camera yaw.
  @property void yaw(float value) {
    updateCameraVectors;
    _yaw = value;
  }

  /// Set camera pitch.
  @property void pitch(float value) {
    checkPitchLimits;
    updateCameraVectors;
    _pitch = value;
  }

  /// Set camera zNear.
  @property void zNear(float value) {
    checkZNearLimits;
    _zNear = value;
  }

  /// Set camera zFar.
  @property void zFar(float value) {
    checkZFarLimits;
    _zFar = value;
  }

  /**
   * Set keyboard listener using a camera movement direction.
   * Works only if camera keyboard listener isn't locked.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) processKeyboard(CameraMovement direction) {
    if (!keyboardLocked) {
      const float velocity = movementSpeed * Time.getDelta();
      preset.runKeyboardProcess(this, direction, velocity);
    }

    return this;
  }

  /**
   * Set mouse move listener using x and y offsets.
   * Works only if camera mouse move listener isn't locked.
   * If it works then it updates camera vectors at the end.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) processMouseMovement(float xOffset, float yOffset) {
    if (!mouseMoveLocked) {
      xOffset *= mouseSensitivity;
      yOffset *= mouseSensitivity;

      _yaw += xOffset;
      _pitch += yOffset;

      checkPitchLimits;
      updateCameraVectors;
    }

    return this;
  }

  /**
   * Set mouse scroll listener using y offset.
   * Works only if camera mouse scroll listener isn't locked.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) processMouseScroll(float yOffset)   {
    if (!mouseScrollLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= 45.0f)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= 45.0f)
        fieldOfView = 45.0f;
    }

    return this;
  }

  /**
   * Returns camera view matrix.
  **/
  Matrix4F viewMatrix() {
    return Matrix4F.lookAt(
      component!Transform.getLocation,
      component!Transform.getLocation + frontVector,
      upVector
    );
  }

  /**
   * Returns camera projection matrix.
  **/
  Matrix4F projectionMatrix()  {
    return Matrix4F.perspective(
      fieldOfView.radians,
      cast(float)Platform.getWindow.getWidth,
      cast(float)Platform.getWindow.getHeight,
      _zNear,
      _zFar
    );
  }

  private void updateCameraVectors() {
    Vector3F front;

    front.x = cos(radians(_yaw)) * cos(radians(_pitch));
    front.y = sin(radians(_pitch));
    front.z = sin(radians(_yaw)) * cos(radians(_pitch));
    
    frontVector = front.normalized;
    rightVector = cross(frontVector, worldUpVector).normalized;
    upVector = cross(rightVector, frontVector).normalized;
  }

  pragma (inline, true)
  private void checkPitchLimits()   {
    if (constrainPitch) {
      if (_pitch > 89.0f)
        _pitch = 89.0f;
      if (_pitch < -89.0f)
        _pitch = -89.0f;
    }
  }

  pragma (inline, true)
  private void checkZNearLimits()   {
    if (_zNear < 0.001f)
      _zNear = 0.001f;
    if (_zNear > 10_000.0f)
      _zNear = 10_000.0f;
  }

  pragma (inline, true)
  private void checkZFarLimits()   {
    if (_zFar < 0.001f)
      _zFar = 0.0001f;
    if (_zFar > 10_000.0f)
      _zFar = 10_000.0f;
  }
}