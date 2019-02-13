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
import liberty.math.transform;

/// A camera custom setting.
class CameraPreset {
  ///
  void delegate(Camera) runImplicitProcess;
  ///
  void delegate(Camera, CameraMovement, float) runKeyboardProcess;

  ///
  this(void delegate(Camera) runImplicitProcess,
    void delegate(Camera, CameraMovement, float) runKeyboardProcess)
  do {
    this.runImplicitProcess = runImplicitProcess;
    this.runKeyboardProcess = runKeyboardProcess;
  }

  /// Returns an empty camera preset.
  static typeof(this) getEmpty() {
    return new CameraPreset((camera) {
    }, (camera, direction, velocity) {
    });
  }

  /// Returns implicit camera preset.
  static typeof(this) getDefault() {
    return new CameraPreset((camera) {
      if (Input.getKeyboard.isButtonHold(KeyboardButton.W))
        camera.processKeyboard(CameraMovement.FORWARD);
      if (Input.getKeyboard.isButtonHold(KeyboardButton.S))
        camera.processKeyboard(CameraMovement.BACKWARD);
      if (Input.getKeyboard.isButtonHold(KeyboardButton.A))
        camera.processKeyboard(CameraMovement.LEFT);
      if (Input.getKeyboard.isButtonHold(KeyboardButton.D))
        camera.processKeyboard(CameraMovement.RIGHT);
    }, (camera, direction, velocity) {
      final switch (direction) with (CameraMovement) {
        case FORWARD:
          camera.component!Transform.setLocation!"+="(camera.frontVector * velocity);
          break;
        case BACKWARD:
          camera.component!Transform.setLocation!"-="(camera.frontVector * velocity);
          break;
        case LEFT:
          camera.component!Transform.setLocation!"-="(camera.rightVector * velocity);
          break;
        case RIGHT:
          camera.component!Transform.setLocation!"+="(camera.rightVector * velocity);
          break;
        case UP:
          camera.component!Transform.setLocation!"+="(camera.upVector * velocity);
          break;
        case DOWN:
          camera.component!Transform.setLocation!"-="(camera.upVector * velocity);
      }
    });
  }
}
