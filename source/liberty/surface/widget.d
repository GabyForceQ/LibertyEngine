/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/widget.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.widget;

version (none) :

import liberty.input.impl;
import liberty.material.impl;
import liberty.math.vector;
import liberty.model.impl;
import liberty.scene.constants;
import liberty.scene.services;
import liberty.surface.impl;

/**
 *
**/
class Widget : IUpdateable {
  private {
    string id;
    Surface surface;
    Vector2I index;
    int zIndex = 0;
    Model model;

    // setVisibility, getVisibility
    Visibility visibility;
  }

  /**
   *
  **/
  this(string id, Surface surface) {
    this.id = id;
    this.surface = surface;


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
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setIndex(int x, int y) pure nothrow {
    return setIndex(Vector2I(x, y));
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setIndex(Vector2I value) pure nothrow {
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
   * Returns reference to this so it can be used in a stream.
  **/
  final typeof(this) setZIndex(int value) pure nothrow {
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
   * Set the 3D model of the widget.
   * Returns reference to this so it can be used in a stream.
  **/
  final typeof(this) setModel(Model model) pure nothrow {
    this.model = model;
    return this;
  }

  /**
   * Returns the 3D model of the widget.
  **/
  final Model getModel() pure nothrow {
    return model;
  }

  /**
   * Set the visibility of the widget.
   * See $(D Visibility) enumeration for possible values.
   * Returns reference to this so it can be used in a stream.
  **/
  final typeof(this) setVisibility(Visibility visibility) pure nothrow {
    this.visibility = visibility;
    return this;
  }

  /**
   * Returns the visibility of the widget.
   * See $(D Visibility) enumeration for possible values.
  **/
  final Visibility getVisibility() pure nothrow const {
    return visibility;
  }

  override void update() {}
}