/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/demo/config.d)
 * Documentation:
 * Coverage:
**/
module demo.config;

import liberty.engine;

void setDemoCameraPreset() {
  CoreEngine
    .getScene()
    .getActiveCamera()
    .setPosition(-5.0f, 3.0f, 1.0f)
    .setMovementSpeed(100.0f)
    .getPreset()
    .setKeyboardProcess((camera, direction, velocity) {
      switch (direction) with (CameraMovement) {
        case FORWARD:
          camera.setPosition(camera.getPosition() - Vector3F.forward * velocity);
          break;
        
        case BACKWARD:
          camera.setPosition(camera.getPosition() - Vector3F.backward * velocity);
          break;

        case LEFT:
          camera.setPosition(camera.getPosition() + Vector3F.left * velocity);
          break;
        
        case RIGHT:
          camera.setPosition(camera.getPosition() + Vector3F.right * velocity);
          break;

        default:
          break;
      }
    });
}
