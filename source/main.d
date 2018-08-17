module main;

import liberty.engine;

mixin(EngineRun);

///
void libertyMain() {
  auto a = new Scene("DefaultScene");

  Logic.self
    .getViewport()
    .getActiveScene()
    .getTree()
    .spawn!Player("player", true);

  Renderer.self.disableVSync();
}

///
final class Player : WorldObject, IRenderable {
  mixin(NodeBody);
  ///
  int lives = 6;

  ///
  Sprite sprite = new Sprite();

  ///
  override void start() {
    this.sprite.initialize(100.0f, 100.0f, 200.0f, 200.0f, "res/textures/texture_demo.bmp");
  }

  ///
  override void update(in float deltaTime) {
  }

  ///
  void render() {
    this.sprite.render();
  }
}