/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/camera/preset.d)
 * Documentation:
 * Coverage:
**/
module liberty.camera.preset;

import liberty.core.engine;
import liberty.input.impl;
import liberty.input.keyboard.constants;
import liberty.camera;

/**
 * A camera custom setting.
**/
class CameraPreset {
  private {
    void delegate(Camera camera) runImplicitDelegate;
    void delegate(Camera, CameraMovement, float) runKeyboardProcess;
  }

  /**
   *
  **/
  this(void delegate(Camera camera) runImplicitDelegate,
    void delegate(Camera, CameraMovement, float) runKeyboardProcess)
  do {
    this.runImplicitDelegate = runImplicitDelegate;
    this.runKeyboardProcess = runKeyboardProcess;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  CameraPreset setImplicit(void delegate(Camera camera) runImplicitDelegate) {
    this.runImplicitDelegate = runImplicitDelegate;
    return this;
  }

  package(liberty) void runImplicit(Camera camera) {
    runImplicitDelegate(camera);
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  CameraPreset setKeyboardProcess(void delegate(Camera, CameraMovement, float) runKeyboardProcess) {
    this.runKeyboardProcess = runKeyboardProcess;
    return this;
  }

  package void processKeyboard(Camera camera, CameraMovement direction, float velocity) {
    runKeyboardProcess(camera, direction, velocity);
  }

  /**
   * Returns an empty camera preset.
  **/
  static CameraPreset getEmpty() {
    return new CameraPreset((Camera camera) {
    }, (camera, direction, velocity) {
    });
  }

  /**
   * Returns implicit camera preset.
  **/
  static CameraPreset getDefault() {
    return new CameraPreset((Camera camera) {
      if (Input.getKeyboard().isButtonHold(KeyboardButton.W))
				camera.processKeyboard(CameraMovement.FORWARD);

			if (Input.getKeyboard().isButtonHold(KeyboardButton.S))
				camera.processKeyboard(CameraMovement.BACKWARD);

			if (Input.getKeyboard().isButtonHold(KeyboardButton.A))
				camera.processKeyboard(CameraMovement.LEFT);

			if (Input.getKeyboard().isButtonHold(KeyboardButton.D))
				camera.processKeyboard(CameraMovement.RIGHT);
    }, (camera, direction, velocity) {
      final switch (direction) with (CameraMovement) {
        case FORWARD:
          camera.getTransform().setAbsoluteLocation!"+="(camera.frontVector * velocity);
          break;
        
        case BACKWARD:
          camera.getTransform().setAbsoluteLocation!"-="(camera.frontVector * velocity);
          break;

        case LEFT:
          camera.getTransform().setAbsoluteLocation!"-="(camera.rightVector * velocity);
          break;

        case RIGHT:
          camera.getTransform().setAbsoluteLocation!"+="(camera.rightVector * velocity);
          break;

        case UP:
          camera.getTransform().setAbsoluteLocation!"+="(camera.upVector * velocity);
          break;

        case DOWN:
          camera.getTransform().setAbsoluteLocation!"-="(camera.upVector * velocity);
      }
    });
  }
}