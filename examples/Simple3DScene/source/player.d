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
		spawn!RectangleShape("RectShape").transform.translateY(1.5f);
		spawn!RectangleShape("Terrain").transform.rotateX(radians(-90.0f));
		spawn!Camera("Camera").position(1.0f, 1.0f, 5.0f);
		scene.activeCamera = child!Camera("Camera");
		child!RectangleShape("Terrain").transform.scale(5.0f, 5.0f, 0.0f);
	}

	override void update(in float deltaTime) {
		if (Input.get.isKeyHold(KeyCode.Up)) {
			child!RectangleShape("RectShape").transform.translateY(0.5f * deltaTime);
		}
		if (Input.get.isKeyHold(KeyCode.Down)) {
			child!RectangleShape("RectShape").transform.translateY(-0.5f * deltaTime);
		}
		if (Input.get.isKeyHold(KeyCode.Left)) {
			child!RectangleShape("RectShape").transform.translateX(-0.5f * deltaTime);
		}
		if (Input.get.isKeyHold(KeyCode.Right)) {
			child!RectangleShape("RectShape").transform.translateX(0.5f * deltaTime);
		}
	}
}
