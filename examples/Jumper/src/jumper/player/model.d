module jumper.player.model;

import liberty.engine;

@Model
struct PlayerModel {

    mixin(Serialize);

    private {

        @Required
        int lives = 5;

    }

}