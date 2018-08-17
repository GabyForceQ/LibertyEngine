module jumper.player;

import liberty.engine;

class Player : WorldObject {
  mixin(NodeBody);

  @Property
  int lives = 5;

  bool isAlive() {
    return lives >= 0;
  }
}