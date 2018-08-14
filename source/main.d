module main;

import liberty.engine;

mixin(EngineRun);

@Model
struct PlayerModel {
    int lives = 6;
}

@View
struct PlayerView {

}

@Controller
class Player : Node {

    mixin(BindModel);
    mixin(BindView);
    mixin(NodeBody);

    override void start() {

    }

    override void update() {

    }

}