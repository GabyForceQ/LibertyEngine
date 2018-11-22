/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/services.d)
 * Documentation:
 * Coverage:
 *
 *  TODO:
 *    - add IProcessable service for Physics Engine sync
**/
module liberty.services;

/**
 * Service used in startable scene nodes.
**/
interface IStartable {
	/**
	 * Called after all scene nodes instantiation.
	**/
	void start();
}

/**
 * Service used in updateable scene nodes.
**/
interface IUpdateable {
	/**
	 * Called every frame to update the current state of the scene node.
	**/
	void update();
}

/**
 * Service used in renderable scene nodes.
**/
interface IRenderable {
  /**
   * Called every frame to render the scene node.
  **/
	void render();
}

/**
 *
**/
interface ISerializable {
  /**
   *
  **/
  void serialize();

  /**
   *
  **/
  void deserialize();
}