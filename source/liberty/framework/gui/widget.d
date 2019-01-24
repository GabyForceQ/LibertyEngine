/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/widget.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.widget;

import liberty.input.impl;
import liberty.material.impl;
import liberty.math.transform;
import liberty.math.vector;
import liberty.model.impl;
import liberty.scene.constants;
import liberty.scene.services;
import liberty.framework.gui.impl;

import liberty.scene.entity;

/**
 *
**/
class Widget : Entity {
  private {
    Gui gui;
    Vector2I index;
    int zIndex = 0;
  }

  /**
   *
  **/
  this(string id, Gui gui) {
    super(id);
    this.gui = gui;

    if (gui.getRootCanvas !is null)
      gui.getRootCanvas.addWidget(this);
  }

  /**
   *
  **/
  final Gui getGui() pure nothrow {
    return gui;
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
    Vector2F mousePos = Input.getMouse.getPostion;
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

  override void update() {}
}