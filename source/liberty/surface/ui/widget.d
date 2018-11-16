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
import liberty.surface.impl;
import liberty.graphics.material.impl;
import liberty.primitive.model;
import liberty.services;
import liberty.surface.model;
import liberty.input.impl;
import liberty.surface.vertex;
import liberty.surface.ui.button;

/**
 *
**/
abstract class Widget : IRenderable, IUpdatable {
  /**
   * Renderer component used for rendering.
  **/
  Renderer!(SurfaceVertex, Surface) renderer;

  private {
    string id;
    Surface surface;
    Transform2D transform;
    Vector2I index;
  }

  /**
   *
  **/
  this(string id, Surface surface) {
    renderer = new Renderer!(SurfaceVertex, Surface)(this, (new SurfaceModel([Material.getDefault()])
      .build(uiSquareVertices, uiSquareIndices)));

    this.id = id;
    this.surface = surface;

    transform = new Transform2D(this);
    surface.addWidget(this);
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
  final Surface getSurface() pure nothrow {
    return surface;
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
  Widget setIndex(int x, int y) pure nothrow {
    return setIndex(Vector2I(x, y));
  }

  /**
   *
  **/
  Widget setIndex(Vector2I value) pure nothrow {
    index = value;
    return this;
  }

  /**
   *
  **/
  final Vector2I getIndex() pure nothrow {
    return index;
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
  final Renderer!(SurfaceVertex, Surface) getRenderer() {
    return renderer;
  }

  override void update() {
    
  }
}

private uint[6] uiSquareIndices = [
  0, 1, 2,
  0, 2, 3
];

private SurfaceVertex[] uiSquareVertices = [
  SurfaceVertex(Vector3F(-1.0f,  1.0f, 0.0f), Vector2F(0.0f, 1.0f)),
  SurfaceVertex(Vector3F(-1.0f, -1.0f, 0.0f), Vector2F(0.0f, 0.0f)),
  SurfaceVertex(Vector3F( 1.0f, -1.0f, 0.0f), Vector2F(1.0f, 0.0f)),
  SurfaceVertex(Vector3F( 1.0f,  1.0f, 0.0f), Vector2F(1.0f, 1.0f))
];

/**
 *
**/
enum Event : string {
  /**
   *
  **/
  MouseLeftClick = "MouseLeftClick",

  /**
   *
  **/
  MouseMiddleClick = "MouseMiddleClick",

  /**
   *
  **/
  MouseRightClick = "MouseRightClick",

  /**
   *
  **/
  MouseOver = "MouseOver",

  /**
   *
  **/
  MouseMove = "MouseMove",

  /**
   *
  **/
  Update = "Update"
}