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
      Vector3F.zero,
      Vector3F(1.2f, 0.0f, 0.0f),
      Vector3F(-1.2f, 0.0f, 0.0f),
      Vector3F(0.0f, 1.2f, 0.0),
      Vector3F(0.0f, -1.2f, 0.0f)
    ];
    BSPTriangle triangle;
    BSPSquare square;
    BSPPyramid pyramid;
    PointLight light;
    float rotationSpeed = 100.0f;
    float direction = 1.0f;
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
      .setPosition(Vector3F(0.0f, 0.0f, 2.0f));
    (pyramid = spawn!BSPPyramid("Pyramid"))
      .getTransform()
      .translate(Vector3F(3.0f, 0.0f, 1.0f))
      .rotatePitch(90.0f);
    (square = spawn!BSPSquare("Square"))
      .getTransform()
      .translate(Vector3F(4.5f, 0.0f, 0.0f));
    (triangle = spawn!BSPTriangle("Triangle"))
      .getTransform()
      .translate(Vector3F(6.0f, 0.0f, 0.0f));
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
        rotationSpeed += 0.2f;
      else
        rotationSpeed = 5000.0f;
    }
    
    if (Input.isKeyHold(KeyCode.X)) {
      if (rotationSpeed > 0.2f)
        rotationSpeed -= 0.2f;
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
      cubes[0].getTransform().translate(Vector3F(-2.0f * Time.getDelta(), 0.0f, 0.0f));

    if (Input.isKeyHold(KeyCode.RIGHT))
      cubes[0].getTransform().translate(Vector3F(2.0f * Time.getDelta(), 0.0f, 0.0f));
    
    if (Input.isKeyHold(KeyCode.UP))
      cubes[0].getTransform().translate(Vector3F(0.0f, 2.0f * Time.getDelta(), 0.0f));

    if (Input.isKeyHold(KeyCode.DOWN))
      cubes[0].getTransform().translate(Vector3F(0.0f, -2.0f * Time.getDelta(), 0.0f));

    if (Input.isKeyDown(KeyCode.ENTER))
      getScene().getActiveCamera().getPreset().setImplicit(() {
        if (Input.isKeyHold(KeyCode.UP))
          getScene().getActiveCamera().processKeyboard(CameraMovement.FORWARD);
        if (Input.isKeyHold(KeyCode.DOWN))
          getScene().getActiveCamera().processKeyboard(CameraMovement.BACKWARD);
        if (Input.isKeyHold(KeyCode.LEFT))
          getScene().getActiveCamera().processKeyboard(CameraMovement.LEFT);
        if (Input.isKeyHold(KeyCode.RIGHT))
          getScene().getActiveCamera().processKeyboard(CameraMovement.RIGHT);
      });
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