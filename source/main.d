module main;

import liberty.engine;
import derelict.sdl2.sdl;

mixin(EngineRun);

///
void libertyMain() {
  auto a = new Scene("DefaultScene");

  CoreEngine.self
    .getViewport()
    .getScene()
    .getTree()
    .spawn!Player("player", true);
    
  GraphicsEngine.self.enableVSync();
  GraphicsEngine.self.enableAlphaBlend();

}

final class Player : Actor, IRenderable {
	mixin(NodeBody);

  Material material;
  Mesh mesh;

	override void start() {
		spawn!Camera("Camera").setPosition(1.0f, 1.0f, 5.0f);
		getScene().setActiveCamera(child!Camera("Camera"));
    
    material = new Material(Texture(), Vector3F(0.3f, 0.5f, 0.2f));
    material.texture = ResourceManager.self.getTexture("res/textures/texture_demo.bmp");

    mesh = new Mesh();
    Vertex[] data = [
      Vertex(Vector3F(-1, -1, 0), Vector2F(0, 0)),
      Vertex(Vector3F( 0,  1, 0), Vector2F(0.5f, 0)),
      Vertex(Vector3F( 1, -1, 0), Vector2F(1, 0)),
      Vertex(Vector3F( 0, -1, 1), Vector2F(0.5f, 1.0f))
    ];
    int[] indices = [
      3, 1, 0,
      2, 1, 3,
      0, 1, 2,
      0, 2, 3
    ];
    mesh.addVertices(data, indices);
	}

	override void update(in float deltaTime) {
		
	}

  void render() {
    material.texture.bind();

    GraphicsEngine.self.shaderProgram.loadUniform("model", transform.modelMatrix);
    GraphicsEngine.self.shaderProgram.loadUniform("uProjection", getScene().getActiveCamera().getProjection());
    GraphicsEngine.self.shaderProgram.loadUniform("uView", getScene().getActiveCamera().getView());
    
    GraphicsEngine.self.shaderProgram.loadUniform("uColor", material.color);
    mesh.render();
  }
}


/*

final class Player : UniqueActor, IRenderable {
  mixin(NodeBody);

  Transform transform;
  float temp = 0.0f;
  Mesh mesh;
  Camera camera;
  Material material;

  override void start() {
    material = new Material(Texture(), Vector3F(0.3f, 0.5f, 0.2f));
    material.texture = ResourceManager.self.getTexture("res/textures/texture_demo.bmp");

    mesh = new Mesh();
    Vertex[] data = [
      Vertex(Vector3F(-1, -1, 0), Vector2F(0, 0)),
      Vertex(Vector3F( 0,  1, 0), Vector2F(0.5f, 0)),
      Vertex(Vector3F( 1, -1, 0), Vector2F(1, 0)),
      Vertex(Vector3F( 0, -1, 1), Vector2F(0.5f, 1.0f))
    ];
    int[] indices = [
      3, 1, 0,
      2, 1, 3,
      0, 1, 2,
      0, 2, 3
    ];
    mesh.addVertices(data, indices);

    camera = new Camera("DefCamera", this);

    //mesh = ResourceManager.self.loadMesh("res/models/box.obj");
    //camera.setProjection(70.0f, 1600, 900, 0.1f, 1000.0f);
    //transform.setCamera(camera);
  }

  override void update(in float deltaTime) {
    camera.update(deltaTime);
    temp += deltaTime;
    transform.setTranslation(sin(temp), 0, -5);
    //transform.setRotationAngle(radians(sin(temp) * 180.0f));
    //transform.setRotation(0, 1, 0);
    //transform.setScale(0.7 * sin(temp), 0.7 * sin(temp), 0.7 * sin(temp));
  }

  void render() {
    material.texture.bind();

    Renderer.self._colorProgram.loadUniform("model", transform.modelMatrix);
    Renderer.self._colorProgram.loadUniform("uProjection", camera.getProjection());
    Renderer.self._colorProgram.loadUniform("uView", camera.getView());
    
    Renderer.self._colorProgram.loadUniform("uColor", material.color);

    mesh.render();
  }
}

*/