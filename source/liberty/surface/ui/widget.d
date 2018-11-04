/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/ui/widget.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.ui.widget;

import liberty.math.vector;
import liberty.graphics.renderer;
import liberty.surface.transform;
import liberty.surface.ui.frame;
import liberty.graphics.vertex;
import liberty.graphics.material.impl;
import liberty.primitive.model;
import liberty.services;
import liberty.surface.model;
import liberty.input.impl;

/**
 *
**/
abstract class Widget : IRenderable, IUpdatable {
  /**
   * Renderer component used for rendering.
  **/
  Renderer!(UIVertex, Frame) renderer;

  private {
    string id;
    Frame frame;
    Transform2D transform;
  }

  /**
   *
  **/
  this(string id, Frame frame) {
    renderer = new Renderer!(UIVertex, Frame)(this, (new SurfaceModel([Material.getDefault()])
      .build(uiSquareVertices, uiSquareIndices)));

    this.id = id;
    this.frame = frame;

    transform = new Transform2D(this);
    frame.addWidget(this);
  }

  /**
   *
  **/
  final string getId() pure nothrow const {
    return id;
  }

  /**
   *
  **/
  final override void render() {
    renderer.draw();
  }

  /**
   *
  **/
  final Frame getFrame() pure nothrow {
    return frame;
  }

  /**
   *
  **/
  final Transform2D getTransform() pure nothrow {
    return transform;
  }

  /**
   *
  **/
  final bool isMouseColliding() {
    Vector2F mousePos = Input.getMousePostion();
    return mousePos.x >= transform.getPosition.x - transform.getExtent.x / 2 && 
      mousePos.x <= transform.getPosition.x + transform.getExtent.x / 2 && 
      mousePos.y >= transform.getPosition.y - transform.getExtent.y / 2 && 
      mousePos.y <= transform.getPosition.y + transform.getExtent.y / 2;
  }

  /**
   * Returns reference to the current renderer component.
  **/
  final Renderer!(UIVertex, Frame) getRenderer() {
    return renderer;
  }

  override void update() {
    
  }
}

private uint[6] uiSquareIndices = [
  0, 1, 2,
  0, 2, 3
];

private UIVertex[] uiSquareVertices = [
  UIVertex(Vector3F(-1.0f,  1.0f, 0.0f), Vector2F(0.0f, 1.0f)),
  UIVertex(Vector3F(-1.0f, -1.0f, 0.0f), Vector2F(0.0f, 0.0f)),
  UIVertex(Vector3F( 1.0f, -1.0f, 0.0f), Vector2F(1.0f, 0.0f)),
  UIVertex(Vector3F( 1.0f,  1.0f, 0.0f), Vector2F(1.0f, 1.0f))
];