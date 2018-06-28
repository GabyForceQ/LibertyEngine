/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/CrystalEngine/blob/master/source/crystal/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module crystal.engine;
version (__NoDefaultImports__) {
} else {
	public {
		import crystal.ai;
		import crystal.animation;
		import crystal.audio;
		import crystal.core;
		import crystal.graphics;
		import crystal.math;
		import crystal.physics;
		import crystal.ui;
	}
}
version (__BasicSTD__) {
	public {
		import std.math;
		import std.random;
		import std.stdio;
		import std.conv;
		import std.string;
		import std.datetime;
	}
}