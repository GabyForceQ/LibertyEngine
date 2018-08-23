module main;

import liberty.engine;
import derelict.sdl2.sdl;

mixin(EngineRun);

///
void libertyMain() {
  auto a = new Scene("DefaultScene");

  Logic.self
    .getViewport()
    .getActiveScene()
    .getTree()
    .spawn!Player("player", true);
    
  Renderer.self.enableVSync();
  Renderer.self.enableAlphaBlend();
}

final class Player : UniqueActor, IRenderable {
  mixin(NodeBody);

  Transform transform;
  float temp = 0.0f;
  Mesh mesh;

  override void start() {
    mesh = new Mesh();
    Vertex3[] data = [
      Vertex3(Vector3F(-1, -1, 0)),
      Vertex3(Vector3F( 0,  1, 0)),
      Vertex3(Vector3F( 1, -1, 0)),
      Vertex3(Vector3F( 0, -1, 1))
    ];
    int[] indices = [
      0, 1, 3,
      3, 1, 2,
      2, 1, 0,
      0, 2, 3
    ];
    mesh.addVertices(data, indices);
  }

  override void update(in float deltaTime) {
    temp += deltaTime;
    transform.setTranslation(sin(temp), 0, 0);
    transform.setRotationAngle(radians(sin(temp) * 180.0f));
    transform.setRotation(0, 1, 0);
    transform.setScale(sin(temp), sin(temp), sin(temp));
  }

  void render() {
    Renderer.self._colorProgram.loadUniform("uTransform", transform.getTransformation());
    mesh.render();
  }
}

/*

///
class Bullet {
  private {
    int _lifeTime;
    float _speed;
    Vector2F _direction;
    Vector2F _position;
    Sprite sprite;
  }

  ~this() {
    sprite.destroy();
  }

  int getLifeTime() { return _lifeTime; }

  static void removeExpired(ref Bullet[] bullets) {
    import std.algorithm.mutation : remove;

    bool noExpired = true;
    while (noExpired) {
      foreach(i, b; bullets) {
        if (!b.getLifeTime()) {
          bullets = bullets.remove(i);
          b.destroy();
          break;
        }
      }
      noExpired = false;
    }
  }

  void start() {
    sprite = new Sprite();
    sprite.initialize(0.0f, 0.0f, 40.0f, 40.0f, "res/textures/texture_demo.bmp");
  }

  void update() {
    _position += _direction * _speed;
    _lifeTime--;
  }

  void initialize(
    Vector2F position, 
    Vector2F direction, 
    float speed,
    int lifeTime
  ) {
    _position = position;
    _direction = direction;
    _speed = speed;
    _lifeTime = lifeTime;
  }

  void render() {
    sprite.initialize(_position.x, _position.y, 40.0f, 40.0f, "res/textures/texture_demo.bmp");
    sprite.render();
  }
}

///
final class Player : UniqueActor, IRenderable {
  mixin(NodeBody);
  ///
  int lives = 6;

  float i = 0.0f;

  ///////////////////
  Sprite player;
  Sprite[5] tiles;
  ///////////////////

  ///
  SpriteBatch spriteBatch = new SpriteBatch();

  Bullet[] bullets;

  ///
  override void start() {
  ///////////////////
    player = new Sprite();
    player.initialize(0.0f, 0.0f, 100.0f, 100.0f, "res/textures/texture_demo.bmp");
    foreach (i; 0..5) {
      tiles[i] = new Sprite();
      tiles[i].initialize(i * 100.0f, 100.0f, 100.0f, 100.0f, "res/textures/texture_demo.bmp");
    }
  ///////////////////
  
    //spriteBatch.initialize();
  }

  ///
  override void update(in float deltaTime) {
    if (Input.self.isKeyDown(SDLK_LEFT)) {
      player.initialize(0.0f + --(--(--i)), 0.0f, 100.0f, 100.0f, "res/textures/texture_demo.bmp");
    }

    if (Input.self.isKeyDown(SDLK_RIGHT)) {
      player.initialize(0.0f + ++(++(++i)), 0.0f, 100.0f, 100.0f, "res/textures/texture_demo.bmp");
    }

    if (Input.self.isKeyDown(SDL_BUTTON_LEFT)) {
      Vector2F mouseCoords = Vector2F(
        cast(float)Input.self.mousePosition().x,
        cast(float)Input.self.mousePosition().y,
      );
      mouseCoords = Logic.self.getCamera().getWorldCoordsFromScreen(mouseCoords);

      Vector2F playerPos = Vector2F.zero;
      Vector2F direction = mouseCoords - playerPos;
      direction.normalize();

      auto bul = new Bullet();
      bul.initialize(playerPos, direction, 5.0f, 100);
      bul.start();
      bullets ~= bul;
    }

    foreach (b; bullets) {
      b.update();
    }

    Bullet.removeExpired(bullets);
  }

  ///
  void render() {
  ///////////////////
    player.render();
    foreach (i; 0..5) {
      tiles[i].render();
    }
  ///////////////////
    foreach (b; bullets) {
      b.render();
    }
    
    
    spriteBatch.begin();

    Vector4F position = Vector4F(50.0f, 50.0f, 300.0f, 300.0f);
    Vector4F uv = Vector4F(0.0f, 0.0f, 1.0f, 1.0f);
    Texture texture = ResourceManager.self.
      getTexture("res/textures/texture_demo.bmp");
    Color color;
    color.r = 255;
    color.g = 255;
    color.b = 255;
    color.a = 255;

    spriteBatch.draw(position, uv, texture.id, 0.0f, color);

    spriteBatch.end();
    spriteBatch.render();
  }
}

*/