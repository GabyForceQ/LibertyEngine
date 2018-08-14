module jumper.player.controller;

import liberty.engine;

import jumper.player.model;
import jumper.player.view;

@Controller
class Player : Actor {

    mixin(BindModel);
    mixin(BindView);
    mixin(NodeBody);

    bool isAlive() {
        return this.model.get!int("lives") >= 0;
    }

}