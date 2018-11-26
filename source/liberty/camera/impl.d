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
import liberty.scene.meta;
import liberty.scene.node;
import liberty.scene.impl;

/**
 * Represents the view of the observer.
 * Everything that is rendered to the screen is processed within the projection matrix and view matrix of a camera.
 * Inheriths $(D SceneNode) class and encapsulates $(D NodeConstructor) macro.
 * It has a custom constructor that calls: $(D updateCameraVectors) and adds default $(D CameraPreset).
**/
final class Camera : SceneNode {
  mixin NodeConstructor!(q{
    this.updateCameraVectors();
    this.preset = CameraPreset.getDefault();
    this.getTransform().setRelativeLocation(0.0f, 3.0f, 4.0f);
  });

  package {
    // getFrontVector
    Vector3F frontVector = Vector3F.forward;
    // getUpVector
    Vector3F upVector = Vector3F.up;
    // getRightVector
    Vector3F rightVector = Vector3F.zero;
    // getWorldUpVector
    Vector3F worldUpVector = Vector3F.up;

    // setYaw, setDefaultYaw, getYaw
    float yaw = CAMERA_DEFAULT_YAW;
    // setPitch, setDefaultPitch, getPitch
    float pitch = CAMERA_DEFAULT_PITCH;
    // setMovementSpeed, setDefaultMovementSpeed, getMovementSpeed
    float movementSpeed = CAMERA_DEFAULT_SPEED;
    // setMouseSensitivity, setDefaultMouseSensitivity, getMouseSensitivity
    float mouseSensitivity = CAMERA_DEFAULT_SENSITIVITY;
    // setFieldOfView, setDefaultFieldOfView, getFieldOfView
    float fieldOfView = CAMERA_DEFAULT_FOV;
    // setZNear, setDefaultZNear, getZNear
    float zNear = CAMERA_DEFAULT_ZNEAR;
    // setZFar, setDefaultZFar, getZFar
    float zFar = CAMERA_DEFAULT_ZFAR;

    // setMouseMoveLocked, isMouseMoveLocked
    bool mouseMoveLocked;
    // setIsMouseScrollLocked, isMouseScrollLocked
    bool mouseScrollLocked;
    // setKeyboardLocked, isKeyboardLocked
    bool keyboardLocked;
    // setConstrainPitchEnabled, isConstrainPitchEnabled
    bool constrainPitch = true;

    // setPreset, getPreset
    CameraPreset preset;
  }

  /**
   * Set keyboard listener using a camera movement direction.
   * Works only if camera keyboard listener isn't locked.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) processKeyboard(CameraMovement direction) {
    if (!keyboardLocked) {
      const float velocity = movementSpeed * Time.getDelta();
      preset.processKeyboard(this, direction, velocity);
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

      yaw += xOffset;
      pitch += yOffset;

      checkPitchLimits();
      updateCameraVectors();
    }

    return this;
  }

  /**
   * Set mouse scroll listener using y offset.
   * Works only if camera mouse scroll listener isn't locked.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) processMouseScroll(float yOffset) pure nothrow {
    if (!mouseScrollLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= CAMERA_DEFAULT_FOV)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= CAMERA_DEFAULT_FOV)
        fieldOfView = CAMERA_DEFAULT_FOV;
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
      zNear,
      zFar
    );
  }

  /**
   * Returns camera front vector.
  **/
  Vector3F getFrontVector() pure nothrow const {
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
  Vector3F getRightVector() pure nothrow const {
    return rightVector;
  }

  /**
   * Returns camera world up vector.
  **/
  Vector3F getWorldUpVector() pure nothrow const {
    return worldUpVector;
  }

  /**
   * Set camera yaw using a template stream function.
   * Assign a value to camera yaw using camera.setYaw(value) or camera.setYaw!"="(value).
   * Increment camera yaw by value using camera.setYaw!"+="(value).
   * Decrement camera yaw by value using camera.setYaw!"-="(value).
   * Multiply camera yaw by value using camera.setYaw!"*="(value).
   * Divide camera yaw by value using camera.setYaw!"/="(value).
   * It updates camera vectors after setting yaw.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setYaw(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("yaw " ~ op ~ " value;");
    updateCameraVectors();
    return this;
  }

  /**
   * Set camera yaw to default value $(D CAMERA_DEFAULT_YAW).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultYaw() pure nothrow {
    yaw = CAMERA_DEFAULT_YAW;
    return this;
  }

  /**
   * Returns camera yaw.
  **/
  float getYaw() pure nothrow const {
    return yaw;
  }

  /**
   * Set camera pitch using a template stream function.
   * Assign a value to camera pitch using camera.setPitch(value) or camera.setPitch!"="(value).
   * Increment camera pitch by value using camera.setPitch!"+="(value).
   * Decrement camera pitch by value using camera.setPitch!"-="(value).
   * Multiply camera pitch by value using camera.setPitch!"*="(value).
   * Divide camera pitch by value using camera.setPitch!"/="(value).
   * It updates camera vectors after setting pitch.
   * Pitch takes value in range [-89.0f, 89.0f] if constrain pitch is set to true.
   * To enable/disable constrain pitch see $(D setConstrainPitchEnabled) function.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setPitch(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("pitch " ~ op ~ " value;");
    checkPitchLimits();
    updateCameraVectors();
    return this;
  }

  /**
   * Set camera pitch to default value $(D CAMERA_DEFAULT_PITCH).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultPitch() pure nothrow {
    yaw = CAMERA_DEFAULT_PITCH;
    return this;
  }

  /**
   * Returns camera pitch.
  **/
  float getPitch() pure nothrow const {
    return pitch;
  }

  /**
   * Set camera movement speed using a template stream function.
   * Assign a value to camera movement speed using camera.setMovementSpeed(value) or camera.setMovementSpeed!"="(value).
   * Increment camera movement speed by value using camera.setMovementSpeed!"+="(value).
   * Decrement camera movement speed by value using camera.setMovementSpeed!"-="(value).
   * Multiply camera movement speed by value using camera.setMovementSpeed!"*="(value).
   * Divide camera movement speed by value using camera.setMovementSpeed!"/="(value).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setMovementSpeed(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("movementSpeed " ~ op ~ " value;");
    return this;
  }

  /**
   * Set camera movement speed to default value $(D CAMERA_DEFAULT_SPEED).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultMovementSpeed() pure nothrow {
    movementSpeed = CAMERA_DEFAULT_SPEED;
    return this;
  }

  /**
   * Returns camera movement speed.
  **/
  float getMovementSpeed() pure nothrow const {
    return movementSpeed;
  }

  /**
   * Set camera mouse sensitivity using a template stream function.
   * Assign a value to camera mouse sensitivity using camera.setMouseSensitivity(value) or camera.setMouseSensitivity!"="(value).
   * Increment camera mouse sensitivity by value using camera.setMouseSensitivity!"+="(value).
   * Decrement camera mouse sensitivity by value using camera.setMouseSensitivity!"-="(value).
   * Multiply camera mouse sensitivity by value using camera.setMouseSensitivity!"*="(value).
   * Divide camera mouse sensitivity by value using camera.setMouseSensitivity!"/="(value).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setMouseSensitivity(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("mouseSensitivity " ~ op ~ " value;");
    return this;
  }

  /**
   * Set camera mouse sensitivity to default value $(D CAMERA_DEFAULT_SENSITIVITY).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultMouseSensitivity() pure nothrow {
    mouseSensitivity = CAMERA_DEFAULT_SENSITIVITY;
    return this;
  }

  /**
   * Returns camera mouse sensitivity.
  **/
  float getMouseSensitivity() pure nothrow const {
    return mouseSensitivity;
  }

  /**
   * Set camera field of view using a template stream function.
   * Assign a value to camera field of view using camera.setFieldOfView(value) or camera.setFieldOfView!"="(value).
   * Increment camera field of view by value using camera.setFieldOfView!"+="(value).
   * Decrement camera field of view by value using camera.setFieldOfView!"-="(value).
   * Multiply camera field of view by value using camera.setFieldOfView!"*="(value).
   * Divide camera field of view by value using camera.setFieldOfView!"/="(value).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setFieldOfView(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("fieldOfView " ~ op ~ " value;");
    return this;
  }

  /**
   * Set camera field of view to default value $(D CAMERA_DEFAULT_FOV).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultFieldOfView() pure nothrow {
    fieldOfView = CAMERA_DEFAULT_FOV;
    return this;
  }

  /**
   * Returns camera field of view.
  **/
  float getFieldOfView() pure nothrow const {
    return fieldOfView;
  }

  /**
   * Set camera zNear using a template stream function.
   * Assign a value to camera zNear using camera.setZNear(value) or camera.setZNear!"="(value).
   * Increment camera zNear by value using camera.setZNear!"+="(value).
   * Decrement camera zNear by value using camera.setZNear!"-="(value).
   * Multiply camera zNear by value using camera.setZNear!"*="(value).
   * Divide camera zNear by value using camera.setZNear!"/="(value).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setZNear(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("zNear " ~ op ~ " value;");
    checkZNearLimits();
    return this;
  }

  /**
   * Set camera zNear to default value $(D CAMERA_DEFAULT_ZNEAR).
   * ZNear takes value in range [0.001f, 10_000.0f].
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultZNear() pure nothrow {
    zNear = CAMERA_DEFAULT_ZNEAR;
    return this;
  }

  /**
   * Returns camera zNear.
  **/
  float getZNear() pure nothrow const {
    return zNear;
  }

  /**
   * Set camera zFar using a template stream function.
   * Assign a value to camera zFar using camera.setZFar(value) or camera.setZFar!"="(value).
   * Increment camera zFar by value using camera.setZFar!"+="(value).
   * Decrement camera zFar by value using camera.setZFar!"-="(value).
   * Multiply camera zFar by value using camera.setZFar!"*="(value).
   * Divide camera zFar by value using camera.setZFar!"/="(value).
   * ZFar takes value in range [0.001f, 10_000.0f].
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setZFar(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin("zFar " ~ op ~ " value;");
    checkZFarLimits();
    return this;
  }

  /**
   * Set camera zFar to default value $(D CAMERA_DEFAULT_ZFAR).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultZFar() pure nothrow {
    zFar = CAMERA_DEFAULT_ZFAR;
    return this;
  }

  /**
   * Returns camera zFar.
  **/
  float getZFar() pure nothrow const {
    return zFar;
  }
  
  /**
   * Set if mouse move listener should be locked or not.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setMouseMoveLocked(bool locked = true) pure nothrow {
    mouseMoveLocked = locked;
    return this;
  }

  /**
   * Returns true if mouse move listener is locked.
  **/
  bool isMouseMoveLocked() pure nothrow const {
    return mouseMoveLocked;
  }

  /**
   * Set if mouse scroll listener should be locked or not.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setIsMouseScrollLocked(bool locked = true) pure nothrow {
    mouseScrollLocked = locked;
    return this;
  }

  /**
   * Returns true if mouse scroll listener is locked.
  **/
  bool isMouseScrollLocked() pure nothrow const {
    return mouseScrollLocked;
  }

  /**
   * Set if keyboard listener should be locked or not.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setKeyboardLocked(bool locked) pure nothrow {
    keyboardLocked = locked;
    return this;
  }

  /**
   * Returns true if keyboard listener is locked.
  **/
  bool isKeyboardLocked() pure nothrow const {
    return keyboardLocked;
  }

  /**
   * Set if constrain pitch should be enabled or not.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setConstrainPitchEnabled(bool enabled = true) pure nothrow {
    constrainPitch = enabled;
    return this;
  }

  /**
   * Returns true if constrain pitch is enabled.
  **/
  bool isConstrainPitchEnabled() pure nothrow const {
    return constrainPitch;
  }

  /**
   * Set camera preset.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setPreset(CameraPreset preset) pure nothrow {
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
   * Register camera to a specific scene (optional).
   * By deafult it is set to $(D CoreEngine) active scene.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerToScene(Scene scene = CoreEngine.getScene()) {
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

  pragma (inline, true)
  private void checkPitchLimits() pure nothrow {
    if (constrainPitch) {
      if (pitch > 89.0f)
        pitch = 89.0f;
      if (pitch < -89.0f)
        pitch = -89.0f;
    }
  }

  pragma (inline, true)
  private void checkZNearLimits() pure nothrow {
    if (zNear < 0.001f)
      zNear = 0.001f;
    if (zNear > 10_000.0f)
      zNear = 10_000.0f;
  }

  pragma (inline, true)
  private void checkZFarLimits() pure nothrow {
    if (zFar < 0.001f)
      zFar = 0.0001f;
    if (zFar > 10_000.0f)
      zFar = 10_000.0f;
  }
}