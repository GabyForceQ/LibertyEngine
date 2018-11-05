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
import liberty.math.vector;
import liberty.math.matrix;
import liberty.core.platform;
import liberty.time;
import liberty.camera.constants;
import liberty.camera.preset;
import liberty.meta;
import liberty.scene.node;
import liberty.scene.impl;

/**
 *
**/
final class Camera : SceneNode {
  mixin(NodeBody);

  package {
    Vector3F frontVector = Vector3F.forward;
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

    bool constrainPitch = true;
  }

  /**
   * Camera custom constructor.
   * Calls: $(D, updateCameraVectors).
   * It adds default $(D, CameraPreset).
  **/
  void constructor() {
    updateCameraVectors();
    preset = CameraPreset.getDefault();
    getTransform().setRelativeLocation(0.0f, 3.0f, 4.0f);
  }

  /**
   * Keyboard listener.
   * Works only if camera input listener isn't locked.
  **/
  Camera processKeyboard(CameraMovement direction) {
    if (!keyboardLocked) {
      const float velocity = movementSpeed * Time.getDelta();
      preset.processKeyboard(this, direction, velocity);
    }

    return this;
  }

  /**
   * Mouse move listener.
   * Works only if camera input listener isn't locked.
  **/
  Camera processMouseMovement(float xOffset, float yOffset) {
    if (!mouseMoveLocked) {
      xOffset *= mouseSensitivity;
      yOffset *= mouseSensitivity;

      yaw += xOffset;
      pitch += yOffset;

      checkPitchLimits();
      updateCameraVectors();
    }

    return this;
  }

  /**
   * Mouse scroll listener.
   * Works only if camera input listener isn't locked.
  **/
  Camera processMouseScroll(float yOffset) {
    if (!mouseScrollLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= FOV)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= FOV)
        fieldOfView = FOV;
    }

    return this;
  }

  /**
   * Returns camera view matrix.
  **/
  Matrix4F getViewMatrix() {
    return Matrix4F.lookAt(
      getTransform().getLocation(),
      getTransform().getLocation() + frontVector,
      upVector
    );
  }

  /**
   * Returns camera projection matrix.
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
   * Returns camera front vector.
  **/
  Vector3F getFrontVector() pure nothrow {
    return frontVector;
  }

  /**
   * Returns camera up vector.
  **/
  Vector3F getUpVector() pure nothrow const {
    return upVector;
  }

  /**
   * Returns camera right vector.
  **/
  Vector3F getRightVector() pure nothrow {
    return rightVector;
  }

  /**
   * Returns camera world up vector.
  **/
  Vector3F getWorldUpVector() pure nothrow const {
    return worldUpVector;
  }

  /**
   * Set camera yaw.
  **/
  Camera setYaw(string op = "=")(float yaw) {
    mixin ("this.yaw " ~ op ~ " yaw;");
    updateCameraVectors();
    return this;
  }

  /**
   * Returns camera yaw.
  **/
  float getYaw() pure nothrow const {
    return yaw;
  }

  /**
   * Set camera pitch.
  **/
  Camera setPitch(string op = "=")(float pitch) {
    mixin ("this.pitch " ~ op ~ " pitch;");
    checkPitchLimits();
    updateCameraVectors();
    return this;
  }

  /**
   * Returns camera pitch.
  **/
  float getPitch() pure nothrow const {
    return pitch;
  }

  /**
   * Set camera movement speed.
  **/
  Camera setMovementSpeed(float movementSpeed) pure nothrow {
    this.movementSpeed = movementSpeed;
    return this;
  }

  /**
   * Returns camera movement speed.
  **/
  float getMovementSpeed() pure nothrow const {
    return movementSpeed;
  }

  /**
   * Set camera mouse sensitivity.
  **/
  Camera setMouseSensitivity(float mouseSensitivity) pure nothrow {
    this.mouseSensitivity = mouseSensitivity;
    return this;
  }

  /**
   * Returns camera mouse sensitivity.
  **/
  float getMouseSensitivity() pure nothrow const {
    return mouseSensitivity;
  }

  /**
   * Set camera field of view.
  **/
  Camera setFieldOfView(float fieldOfView) pure nothrow {
    this.fieldOfView = fieldOfView;
    return this;
  }

  /**
   * Returns camera field of view.
  **/
  float getFieldOfView() pure nothrow const {
    return fieldOfView;
  }

  /**
   *
  **/
  Camera setPreset(CameraPreset preset) pure nothrow {
    this.preset = preset;
    return this;
  }

  /**
   * Returns current camera preset.
  **/
  CameraPreset getPreset() pure nothrow {
    return preset;
  }

  /**
   * Lock camera mouse move listener.
  **/
  Camera lockMouseMove() pure nothrow {
    mouseMoveLocked = true;
    return this;
  }

  /**
   * Unlock camera mouse move listener.
  **/
  Camera unlockMouseMove() pure nothrow {
    mouseMoveLocked = false;
    return this;
  }

  /**
   * Returns true if mouse move listener is locked.
  **/
  bool isMouseMoveLocked() pure nothrow const {
    return mouseMoveLocked;
  }

  /**
   * Lock camera mouse scroll listener.
  **/
  Camera lockMouseScroll() pure nothrow {
    mouseScrollLocked = true;
    return this;
  }

  /**
   * Unlock camera mouse scroll listener.
  **/
  Camera unlockMouseScroll() pure nothrow {
    mouseScrollLocked = false;
    return this;
  }

  /**
   * Returns true if mouse scroll listener is locked.
  **/
  bool isMouseScrollLocked() pure nothrow const {
    return mouseScrollLocked;
  }

  /**
   * Lock camera keyboard listener.
  **/
  Camera lockKeyboard() pure nothrow {
    keyboardLocked = true;
    return this;
  }

  /**
   * Unlock camera keyboard listener.
  **/
  Camera unlockKeyboard() pure nothrow {
    keyboardLocked = false;
    return this;
  }

  /**
   * Returns true if keyboard listener is locked.
  **/
  bool isKeyboardLocked() pure nothrow const {
    return keyboardLocked;
  }

  /**
   *
  **/
  Camera registerToScene(Scene scene = CoreEngine.getScene()) {
    scene.setActiveCamera(this);
    return this;
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

  private void checkPitchLimits() {
    if (constrainPitch) {
      if (pitch > 89.0f)
        pitch = 89.0f;
      if (pitch < -89.0f)
        pitch = -89.0f;
    }
  }
}