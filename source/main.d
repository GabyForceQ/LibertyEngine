/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/main.d)
 * Documentation:
 * Coverage:
**/
module main;

import liberty.engine;

mixin(EngineRun);

/**
 * Example class for player.
**/
final class Player : Actor {
  mixin(NodeBody);

  private {
    BSPCube[5] cubes;
    Vector3F[5] cubesPos = [
      Vector3F(0.0f, 1.0f, 0.0f),
      Vector3F(1.2f, 1.0f, 0.0f),
      Vector3F(-1.2f, 1.0f, 0.0f),
      Vector3F(0.0f, 2.2f, 0.0),
      Vector3F(0.0f, -0.2f, 0.0f)
    ];

    BSPTriangle triangle;
    BSPSquare square;
    BSPPyramid pyramid;
    PointLight light;

    float rotationSpeed = 100.0f;
    float direction = 1.0f;

    StaticMesh mesh;
    Terrain terrain;
  }

  /**
   * Optional.
   * If declared, it is called after all objects instantiation.
  **/
  override void start() {
    foreach (i; 0..5)
      (cubes[i] = spawn!BSPCube("Cube" ~ i.to!string))
        .getTransform()
        .translate(cubesPos[i]);
    
    (light = spawn!PointLight("PointLight"))
      .getTransform().translateY(100.0f);
    
    (pyramid = spawn!BSPPyramid("Pyramid"))
      .getTransform()
      .translate(3.0f, 1.0f, 1.0f)
      .rotatePitch(90.0f);
    
    (square = spawn!BSPSquare("Square"))
      .getTransform()
      .translate(4.5f, 1.0f, 0.0f);
    
    (triangle = spawn!BSPTriangle("Triangle"))
      .getTransform()
      .translate(6.0f, 1.0f, 0.0f);

    (mesh = spawn!StaticMesh("CubeMesh"))
      .getRenderer()
      .setModel(ResourceManager.loadModel("res/models/cube.obj", "res/textures/default.bmp"))
      .getParent()
      .getTransform()
      .translate(0.0f, 1.0f, -10.0f);

    (terrain = spawn!Terrain("Terrain"))
      .build(500.0f);
  }

  /**
   * Optional.
   * If declared, it is called every frame.
  **/
  override void update() {
    static float rotationVelocity = 0.0f;
    rotationVelocity += rotationSpeed * direction * Time.getDelta();
    if (rotationVelocity >= 360.0f)
      rotationVelocity = 0.0f;

    for (int i = 1; i < 5; i += 2)
			cubes[i].getTransform().rotateRoll(rotationVelocity);
	  
    for (int i = 2; i < 5; i += 2)
			cubes[i].getTransform().rotateRoll(-rotationVelocity);

    if (Input.isKeyHold(KeyCode.Z)) {
      if (rotationSpeed < 4999.8f)
        rotationSpeed += 100.0f * Time.getDelta();
      else
        rotationSpeed = 5000.0f;
    }
    
    if (Input.isKeyHold(KeyCode.X)) {
      if (rotationSpeed > 0.2f)
        rotationSpeed -= 100.0f * Time.getDelta();
      else
        rotationSpeed = 0.0f;
    }

    if (Input.isKeyDown(KeyCode.C))
      direction = -direction;
    
    if (Input.isKeyHold(KeyCode.SPACE))
      changeLightColor();

    if (Input.isKeyUp(KeyCode.SPACE))
      light.setColor(Vector3F.one);

    if (Input.isKeyHold(KeyCode.LEFT))
      light.getTransform().translateX(-2.0f * Time.getDelta());

    if (Input.isKeyHold(KeyCode.RIGHT))
      light.getTransform().translateX(2.0f * Time.getDelta());
    
    if (Input.isKeyHold(KeyCode.UP))
      light.getTransform().translateY(2.0f * Time.getDelta());

    if (Input.isKeyHold(KeyCode.DOWN))
      light.getTransform().translateY(-2.0f * Time.getDelta());

    if (Input.isKeyDown(KeyCode.ENTER)) {
      getScene().getActiveCamera().getPreset().setImplicit(() {
        if (Input.isKeyHold(KeyCode.UP))
          getScene().getActiveCamera().processKeyboard(CameraMovement.FORWARD);
        if (Input.isKeyHold(KeyCode.DOWN))
          getScene().getActiveCamera().processKeyboard(CameraMovement.BACKWARD);
        if (Input.isKeyHold(KeyCode.A))
          getScene().getActiveCamera().processKeyboard(CameraMovement.LEFT);
        if (Input.isKeyHold(KeyCode.D))
          getScene().getActiveCamera().processKeyboard(CameraMovement.RIGHT);

        if (Input.isKeyHold(KeyCode.W))
          getScene().getActiveCamera().processKeyboard(CameraMovement.UP);
        if (Input.isKeyHold(KeyCode.S))
          getScene().getActiveCamera().processKeyboard(CameraMovement.DOWN);
      });
      getScene().getActiveCamera().lockMouseMove();
    }
  }

  /**
   *
  **/
  void changeLightColor() {
    light.setColor(Vector3F(
      sin(Time.getTime() * 2.0f),
      sin(Time.getTime() * 1.7f),
      sin(Time.getTime() * 1.3f)
    ));
  }
}

/**
 * Application main.
 * Create a new scene, then spawn a Player,
 * then register the scene to the engine.
**/
void libertyMain() {
  new Scene("Scene")
    .getTree()
    .spawn!Player("Player", false)
    .getScene()
    .register();
}