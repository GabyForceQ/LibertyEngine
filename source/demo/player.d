/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/demo/player.d)
 * Documentation:
 * Coverage:
**/
module demo.player;

import liberty.engine;

/**
 * Example class for player.
**/
final class Player : Actor {
  mixin(NodeBody);

  private {
    BSPCube playerBody;
  }

  /**
   * Optional.
   * If declared, it is called after all objects instantiation.
  **/
  override void start() {
    (playerBody = spawn!BSPCube("Body"))
      .getTransform()
      .translate(-5.0f, 0.5f, -5.0f);
  }

  /**
   * Optional.
   * If declared, it is called every frame.
  **/
  override void update() {
    const float deltaTime = Time.getDelta();
    const float cameraSpeed = getScene().getActiveCamera().getMovementSpeed();

    if (Input.isKeyHold(KeyCode.A))
      playerBody.getTransform().translateX(-cameraSpeed * deltaTime);

    if (Input.isKeyHold(KeyCode.D))
      playerBody.getTransform().translateX(cameraSpeed * deltaTime);
    
    if (Input.isKeyHold(KeyCode.W))
      playerBody.getTransform().translateZ(-cameraSpeed * deltaTime);

    if (Input.isKeyHold(KeyCode.S))
      playerBody.getTransform().translateZ(cameraSpeed * deltaTime);
  }
}