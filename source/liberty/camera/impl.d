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
import liberty.camera.movement;
import liberty.camera.preset;
import liberty.meta;
import liberty.scene.node;
import liberty.scene.impl;

/**
 * Represents the view of the observer.
 * Everything that is rendered to the screen is processed within the projection matrix and view matrix of a camera.
 * Inheriths (D SceneNode) class and encapsulates (D NodeBody) macro.
**/
final class Camera : SceneNode {
  mixin (NodeBody);

  package {
    immutable float DEFAULT_YAW = -90.0f;
    immutable float DEFAULT_PITCH = -30.0f;
    immutable float DEFAULT_SPEED = 3.0f;
    immutable float DEFAULT_SENSITIVITY = 0.1f;
    immutable float DEFAULT_FOV = 45.0f;
    immutable float DEFAULT_ZNEAR = 0.01f;
    immutable float DEFAULT_ZFAR = 1000.0f;

    // getFrontVector
    Vector3F frontVector = Vector3F.forward;
    // getUpVector
    Vector3F upVector = Vector3F.up;
    // getRightVector
    Vector3F rightVector = Vector3F.zero;
    // getWorldUpVector
    Vector3F worldUpVector = Vector3F.up;

    // setYaw, setDefaultYaw, getYaw
    float yaw = DEFAULT_YAW;
    // setPitch, setDefaultPitch, getPitch
    float pitch = DEFAULT_PITCH;
    // setMovementSpeed, setDefaultMovementSpeed, getMovementSpeed
    float movementSpeed = DEFAULT_SPEED;
    // setMouseSensitivity, setDefaultMouseSensitivity, getMouseSensitivity
    float mouseSensitivity = DEFAULT_SENSITIVITY;
    // setFieldOfView, setDefaultFieldOfView, getFieldOfView
    float fieldOfView = DEFAULT_FOV;
    // setZNear, setDefaultZNear, getZNear
    float zNear = DEFAULT_ZNEAR;
    // setZFar, setDefaultZFar, getZFar
    float zFar = DEFAULT_ZFAR;

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
   * Camera custom constructor.
   * Calls: $(D updateCameraVectors).
   * It adds default $(D CameraPreset).
  **/
  void constructor() {
    updateCameraVectors();
    preset = CameraPreset.getDefault();
    getTransform().setRelativeLocation(0.0f, 3.0f, 4.0f);
  }

  /**
   * Set keyboard listener using a camera movement direction.
   * Works only if camera keyboard listener isn't locked.
   * Returns reference to this and can be used in a stream.
  **/
  Camera processKeyboard(CameraMovement direction) {
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
   * Returns reference to this and can be used in a stream.
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
   * Set mouse scroll listener using y offset.
   * Works only if camera mouse scroll listener isn't locked.
   * Returns reference to this and can be used in a stream.
  **/
  Camera processMouseScroll(float yOffset) pure nothrow {
    if (!mouseScrollLocked) {
      if (fieldOfView >= 1.0f && fieldOfView <= DEFAULT_FOV)
        fieldOfView -= yOffset;
      if (fieldOfView <= 1.0f)
        fieldOfView = 1.0f;
      if (fieldOfView >= DEFAULT_FOV)
        fieldOfView = DEFAULT_FOV;
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setYaw(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("yaw " ~ op ~ " value;");
    updateCameraVectors();
    return this;
  }

  /**
   * Set camera yaw to default value (D DEFAULT_YAW).
   * Returns reference to this and can be used in a stream.
  **/
  Camera setDefaultYaw() pure nothrow {
    yaw = DEFAULT_YAW;
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setPitch(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("pitch " ~ op ~ " value;");
    checkPitchLimits();
    updateCameraVectors();
    return this;
  }

  /**
   * Set camera pitch to default value (D DEFAULT_PITCH).
   * Returns reference to this and can be used in a stream.
  **/
  Camera setDefaultPitch() pure nothrow {
    yaw = DEFAULT_PITCH;
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setMovementSpeed(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("movementSpeed " ~ op ~ " value;");
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setMouseSensitivity(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("mouseSensitivity " ~ op ~ " value;");
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setFieldOfView(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("fieldOfView " ~ op ~ " value;");
    return this;
  }

  /**
   * Returns camera field of view.
  **/
  float getFieldOfView() pure nothrow const {
    return fieldOfView;
  }

  /**
   * Set camera zNear a template stream function.
   * Assign a value to camera zNear using camera.setZNear(value) or camera.setZNear!"="(value).
   * Increment camera zNear by value using camera.setZNear!"+="(value).
   * Decrement camera zNear by value using camera.setZNear!"-="(value).
   * Multiply camera zNear by value using camera.setZNear!"*="(value).
   * Divide camera zNear by value using camera.setZNear!"/="(value).
   * Returns reference to this and can be used in a stream.
  **/
  Camera setZNear(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("zNear " ~ op ~ " value;");
    checkZNearLimits();
    return this;
  }

  /**
   * Set camera zNear to default value (D DEFAULT_ZNEAR).
   * ZNear takes value in range [0.001f, 10_000.0f].
   * Returns reference to this and can be used in a stream.
  **/
  Camera setDefaultZNear() pure nothrow {
    zNear = DEFAULT_ZNEAR;
    return this;
  }

  /**
   * Returns camera zNear.
  **/
  float getZNear() pure nothrow const {
    return zNear;
  }

  /**
   * Set camera zFar a template stream function.
   * Assign a value to camera zFar using camera.setZFar(value) or camera.setZFar!"="(value).
   * Increment camera zFar by value using camera.setZFar!"+="(value).
   * Decrement camera zFar by value using camera.setZFar!"-="(value).
   * Multiply camera zFar by value using camera.setZFar!"*="(value).
   * Divide camera zFar by value using camera.setZFar!"/="(value).
   * ZFar takes value in range [0.001f, 10_000.0f].
   * Returns reference to this and can be used in a stream.
  **/
  Camera setZFar(string op = "=")(float value) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    mixin ("zFar " ~ op ~ " value;");
    checkZFarLimits();
    return this;
  }

  /**
   * Set camera zFar to default value (D DEFAULT_ZFAR).
   * Returns reference to this and can be used in a stream.
  **/
  Camera setDefaultZFar() pure nothrow {
    zFar = DEFAULT_ZFAR;
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setMouseMoveLocked(bool locked = true) pure nothrow {
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setIsMouseScrollLocked(bool locked = true) pure nothrow {
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setKeyboardLocked(bool locked) pure nothrow {
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
   * Returns reference to this and can be used in a stream.
  **/
  Camera setConstrainPitchEnabled(bool enabled = true) pure nothrow {
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
   * Returns reference to this and can be used in a stream.
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
   * Register camera to a specific scene (optional).
   * By deafult it is set to (D CoreEngine) active scene.
   * Returns reference to this and can be used in a stream.
  **/
  Camera registerToScene(Scene scene = CoreEngine.getScene()) {
    scene.setActiveCamera(this);
    return this;
  }

  pragma (inline, true)
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
  private void checkPitchLimits() {
    if (constrainPitch) {
      if (pitch > 89.0f)
        pitch = 89.0f;
      if (pitch < -89.0f)
        pitch = -89.0f;
    }
  }

  pragma (inline, true)
  private void checkZNearLimits() {
    if (zNear < 0.001f)
      zNear = 0.001f;
    if (zNear > 10_000.0f)
      zNear = 10_000.0f;
  }

  pragma (inline, true)
  private void checkZFarLimits() {
    if (zFar < 0.001f)
      zFar = 0.0001f;
    if (zFar > 10_000.0f)
      zFar = 10_000.0f;
  }
}