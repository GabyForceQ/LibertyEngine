/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/CrystalEngine/blob/master/examples/Simple3DScene/source/game.d, _game.d)
 * Documentation:
 * Coverage:
 */
module game;

import crystal.engine;
import player;

mixin(NativeServices);

void initSettings() {
	CoreEngine.shouldQuitOnKey(KeyCode.Esc);
	GraphicsEngine.setVSyncEnabled(false);
	GraphicsEngine.setWindowBackgroundColor(0.0f, 0.2f, 0.3f);
	Input.useSystemCursor(SystemCursor.CrossHair);
}

void initScene() {
	Scene mainScene = new Scene("MainScene");
	mainScene.tree.spawn!Player("Player", false);
	mainScene.register();
}
