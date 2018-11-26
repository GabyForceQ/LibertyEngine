/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/widget.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.widget;

import liberty.math.vector;
import liberty.math.transform;
import liberty.surface.impl;
import liberty.graphics.material.impl;
import liberty.primitive.model;
import liberty.services;
import liberty.surface.model;
import liberty.input.impl;
import liberty.surface.vertex;

/**
 *
**/
class Widget : IUpdateable {
  /**
   * Renderer component used for rendering.
  **/
  SurfaceModel model;

  private {
    string id;
    Surface surface;
    Transform2 transform;
    Vector2I index;
    int zIndex = 0;
  }

  /**
   *
  **/
  this(string id, Surface surface, bool hasRenderer) {
    if (hasRenderer) {
      model = new SurfaceModel([Material.getDefault()]);
      model.build(uiSquareVertices, uiSquareIndices);
    }

    this.id = id;
    this.surface = surface;

    transform = new Transform2(this);

    if (surface.getRootCanvas() !is null)
      surface.getRootCanvas().addWidget(this);
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
  final Surface getSurface() pure nothrow {
    return surface;
  }

  /**
   *
  **/
  final Transform2 getTransform() pure nothrow {
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
    Vector2F mousePos = Input.getMouse.getPostion();
    return mousePos.x >= transform.getLocation.x - transform.getScale.x / 2 && 
      mousePos.x <= transform.getLocation.x + transform.getScale.x / 2 && 
      mousePos.y >= transform.getLocation.y - transform.getScale.y / 2 && 
      mousePos.y <= transform.getLocation.y + transform.getScale.y / 2;
  }

  /**
   *
  **/
  final Widget setZIndex(int value) pure nothrow {
    zIndex = value;
    return this;
  }

  /**
   *
  **/
  final int getZIndex() pure nothrow const {
    return zIndex;
  }

  /**
   * Returns the 3D model of the widget.
  **/
  final SurfaceModel getModel() pure nothrow {
    return model;
  }

  override void update() {}
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
enum WidgetType : string {
  /**
   *
  **/
  Canvas = "Canvas",
  
  /**
   *
  **/
  CustomControl = "CustomControl",

  /**
   *
  **/
  Button = "Button",

  /**
   *
  **/
  CustomButton = "CustomButton",
  
  /**
   *
  **/
  CheckBox = "CheckBox",

  /**
   *
  **/
  CustomCheckBox = "CustomCheckBox"
}