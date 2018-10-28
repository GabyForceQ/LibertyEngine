/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/camera/preset.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.camera.preset;

import liberty.core.engine : CoreEngine;
import liberty.core.input.constants : KeyCode;
import liberty.core.input.impl : Input;
import liberty.core.objects.camera.constants : CameraMovement;

import liberty.core.objects.camera;

/**
 *
**/
class CameraPreset {
  private {
    void delegate(Camera camera) runImplicitDelegate;
    void delegate(Camera, CameraMovement, float) runKeyboardProcess;
  }

  /**
   *
  **/
  this(void delegate(Camera camera) runImplicitDelegate, void delegate(Camera, CameraMovement, float) runKeyboardProcess) {
    this.runImplicitDelegate = runImplicitDelegate;
    this.runKeyboardProcess = runKeyboardProcess;
  }

  /**
   *
   * Returns reference to this.
  **/
  CameraPreset setImplicit(void delegate(Camera camera) runImplicitDelegate) {
    this.runImplicitDelegate = runImplicitDelegate;
    return this;
  }

  package(liberty.core) void runImplicit(Camera camera) {
    runImplicitDelegate(camera);
  }

  /**
   *
   * Returns reference to this.
  **/
  CameraPreset setKeyboardProcess(void delegate(Camera, CameraMovement, float) runKeyboardProcess) {
    this.runKeyboardProcess = runKeyboardProcess;
    return this;
  }

  package void processKeyboard(Camera camera, CameraMovement direction, float velocity) {
    runKeyboardProcess(camera, direction, velocity);
  }

  /**
   *
  **/
  static CameraPreset getEmpty() {
    return new CameraPreset((Camera camera) {
    }, (camera, direction, velocity) {
    });
  }

  /**
   *
  **/
  static CameraPreset getDefault() {
    return new CameraPreset((Camera camera) {
      if (Input.isKeyHold(KeyCode.W))
				camera.processKeyboard(CameraMovement.FORWARD);

			if (Input.isKeyHold(KeyCode.S))
				camera.processKeyboard(CameraMovement.BACKWARD);

			if (Input.isKeyHold(KeyCode.A))
				camera.processKeyboard(CameraMovement.LEFT);

			if (Input.isKeyHold(KeyCode.D))
				camera.processKeyboard(CameraMovement.RIGHT);
    }, (camera, direction, velocity) {
      final switch (direction) with (CameraMovement) {
        case FORWARD:
          camera.getTransform().setWorldPosition!"+="(camera.frontVector * velocity);
          break;
        
        case BACKWARD:
          camera.getTransform().setWorldPosition!"-="(camera.frontVector * velocity);
          break;

        case LEFT:
          camera.getTransform().setWorldPosition!"-="(camera.rightVector * velocity);
          break;

        case RIGHT:
          camera.getTransform().setWorldPosition!"+="(camera.rightVector * velocity);
          break;

        case UP:
          camera.getTransform().setWorldPosition!"+="(camera.upVector * velocity);
          break;

        case DOWN:
          camera.getTransform().setWorldPosition!"-="(camera.upVector * velocity);
      }
    });
  }
}