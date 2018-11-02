/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/services.d)
 * Documentation:
 * Coverage:
 *
 *  TODO:
 *    - add IProcessable service for Physics Engine sync
**/
module liberty.core.services;

/**
 * Service used in startable world objects.
**/
interface IStartable {
	/**
	 * Called after all objects instantiation.
	**/
	void start();
}

/**
 * Service used in updatable world objects.
**/
interface IUpdatable {
	/**
	 * Called every frame to update the current state of the object.
	**/
	void update();
}

/**
 * Service used in renderable world objects.
**/
interface IRenderable {
  /**
   * Called every frame to render the object.
  **/
	void render();
}

/**
 *
**/
interface IListener {
  /**
   *
  **/
}