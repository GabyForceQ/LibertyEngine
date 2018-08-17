/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/services.d, _services.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.services;

/**
 *
**/
interface IStartable {
	/**
	 *
	**/
	void start();
}

/**
 *
**/
interface IUpdatable {
	/**
	 *
	**/
	void update(in float deltaTime);
}

/**
 *
**/
interface IProcessable {
	/**
	 *
	**/
	void process();
}

/**
 *
**/
interface IRenderable {
  /**
   *
  **/
	void render();
}
