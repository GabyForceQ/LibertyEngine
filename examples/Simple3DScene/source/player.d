/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/examples/Simple3DScene/source/player.d, _player.d)
 * Documentation:
 * Coverage:
 */
module player;

import liberty.engine;

final class Player : Actor {

	mixin(NodeServices);

	override void start() {
		spawn!RectangleShape("RectShape").transform.rotateX(90.0f);
		spawn!Camera("Camera").position(1.0f, 1.0f, 5.0f);
		scene.activeCamera = child!Camera("Camera");
	}
}
