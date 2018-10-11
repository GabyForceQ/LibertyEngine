/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/entity.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.entity;

import liberty.core.components.renderer : Renderer;
import liberty.core.objects.node : WorldObject;
import liberty.core.services : IRenderable;

/**
 * An entity is a world object that should be rendered to the screen.
**/
abstract class Entity(VERTEX) : WorldObject, IRenderable {
  /**
   *
  **/
  immutable baseType = "Entity";

  /**
   * Renderer component used for rendering.
  **/
  Renderer!VERTEX renderer;

  /**
   * Entity constructor.
  **/
  this(string id, WorldObject parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {
    renderer.draw();
  }

  /**
   * Returns: reference to the current renderer component.
  **/
  ref Renderer!VERTEX getRenderer() {
    return renderer;
  }
}