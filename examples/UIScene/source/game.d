/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/examples/UIScene/source/game.d, _game.d)
 * Documentation:
 * Coverage:
 */
module game;

import liberty.engine;
import hud;

mixin(NativeBody);

void initSettings() {
	CoreEngine.get.shouldQuitOnKey(KeyCode.Esc);
	GraphicsEngine.get.vSyncEnabled = false;
	GraphicsEngine.get.windowBackgroundColor = Vector4F(0.0f, 0.0f, 0.0f, 1.0f);
}

void initScene() {
	auto mainScene = new Scene("MainScene");
	mainScene.tree.spawn!HUD("Hud", false);
	mainScene.register();
}
