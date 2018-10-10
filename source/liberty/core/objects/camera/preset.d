/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/camera/preset.d, _preset.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.camera.preset;

import liberty.core.engine : CoreEngine;
import liberty.core.input.constants : KeyCode;
import liberty.core.input.impl : Input;
import liberty.core.objects.camera.constants : CameraMovement;

/**
 *
**/
class CameraPreset {
  private {
    void delegate() runImplicitDelegate;
  }

  /**
   *
  **/
  this(void delegate() runImplicitDelegate) {
    this.runImplicitDelegate = runImplicitDelegate;
  }

  /**
   *
  **/
  void setImplicit(void delegate() runImplicitDelegate) {
    this.runImplicitDelegate = runImplicitDelegate;
  }

  package(liberty.core) void runImplicit() {
    runImplicitDelegate();
  }

  /**
   *
  **/
  static CameraPreset getDefault() {
    return new CameraPreset(() {
      if (Input.isKeyHold(KeyCode.W))
				CoreEngine.getScene().getActiveCamera().processKeyboard(CameraMovement.FORWARD);
			if (Input.isKeyHold(KeyCode.S))
				CoreEngine.getScene().getActiveCamera().processKeyboard(CameraMovement.BACKWARD);
			if (Input.isKeyHold(KeyCode.A))
				CoreEngine.getScene().getActiveCamera().processKeyboard(CameraMovement.LEFT);
			if (Input.isKeyHold(KeyCode.D))
				CoreEngine.getScene().getActiveCamera().processKeyboard(CameraMovement.RIGHT);
    });
  }
}