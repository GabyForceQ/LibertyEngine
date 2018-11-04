/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/entity.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.entity;

import liberty.components.renderer : Renderer;
import liberty.objects.node : SceneNode;
import liberty.services : IRenderable;

/**
 * An entity is a world object that should be rendered to the screen.
**/
abstract class Entity(VERTEX) : SceneNode, IRenderable {
  /**
   * Renderer component used for rendering.
  **/
  Renderer!VERTEX renderer;

  /**
   * Entity constructor.
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {
    renderer.draw();
  }

  /**
   * Returns reference to the current renderer component.
  **/
  Renderer!VERTEX getRenderer() {
    return renderer;
  }
}