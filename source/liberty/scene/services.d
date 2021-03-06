/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/services.d)
 * Documentation:
 * Coverage:
 *
 *  TODO:
 *    - add IProcessable service for Physics Engine sync
**/
module liberty.scene.services;

import liberty.scene.impl;

/**
 * Service used in startable scene entitys.
**/
interface IStartable {
  /**
   * Called after all scene entitys instantiation.
  **/
  void start();
}

/**
 * Service used in updateable scene entitys.
**/
interface IUpdateable {
  /**
   * Called every frame to update the current state of the scene entity.
  **/
  void update();
}

/**
 * Service used in renderable scene entitys.
**/
interface IRenderable {
  /**
   * Called every frame to render the scene entity.
  **/
  void render(Scene scene);
}

/**
 *
**/
interface IDrawable {
  /**
   *
  **/
  void draw();
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
