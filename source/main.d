module main;

import liberty.engine;

mixin(EngineRun);

///
void libertyMain() {
  auto a = new SceneController("DefaultScene");

  Logic.self
    .getViewport()
    .getActiveScene()
    .getTree()
    .spawn!PlayerController("player", true);
}

///
@Model
struct PlayerModel {
  ///
  int lives = 6;
}

///
@View
struct PlayerView {
  ///
  Sprite sprite = new Sprite();
}

///
@Controller
final class PlayerController : NodeController, IRenderable {
  mixin(BindModel);
  mixin(BindView);
  mixin(NodeBody);

  ///
  override void start() {
    view.sprite.initialize(-1.0f, -1.0f, 1.0f, 1.0f, "res/textures/texture_demo.bmp");
  }

  ///
  override void update(in float deltaTime) {
  }

  ///
  void render() {
    view.sprite.render();
  }
}