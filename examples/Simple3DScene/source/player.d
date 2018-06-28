/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/CrystalEngine/blob/master/examples/Simple3DScene/source/player.d, _player.d)
 * Documentation:
 * Coverage:
 */
module player;

import crystal.engine;

final class Player : Actor {

	mixin(NodeServices);

	override void start() {
		spawn!CubeVolume("Cube").transform.translate(0.0f, 0.0f, 0.0f);
		spawn!Camera("Cam1").position = Vector3F(1.0f, 1.0f, 5.0f);
		scene.activeCamera = child!Camera("Cam1");
	}
}
