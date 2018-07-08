/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/examples/UIScene/source/hud.d, _hud.d)
 * Documentation:
 * Coverage:
 */
module hud;

import liberty.engine;

final class HUD : Canvas {

	mixin(NodeServices);
	mixin(ListenerServices);

	private Button button1;

	override void start() {
		button1 = new Button("Button1", 320, 180, 640, 360);
		startListening(button1);
	}

	@Signal("Button1") {
		
		@Event(Button.MouseMove)
		void changeBackgroundColor() {
			import std.random : uniform;
			float r1 = uniform!"[]"(0.0f, 1.0f);
			float r2 = uniform!"[]"(0.0f, 1.0f);
			float r3 = uniform!"[]"(0.0f, 1.0f);
			GraphicsEngine.get.windowBackgroundColor = Vector4F(r1, r2, r3, 1.0f);
		}
		
		@Event(Button.MouseInside)
		void toggleWireframe() {
			if (Input.get.isKeyDown(KeyCode.Tab)) {
				GraphicsEngine.get.toggleWireframe();
			}
		}
	}
}
