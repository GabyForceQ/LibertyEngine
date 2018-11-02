/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/button.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.button;

import liberty.core.objects.meta : NodeBody;
import liberty.core.ui.widget : Widget;
import liberty.core.ui.frame : Frame;
import liberty.core.input.impl : Input;
import liberty.core.input.constants : MouseButton;

/**
 *
**/
final class Button : Widget {
  private {
    void delegate() onLeftClick = null;
    void delegate() onMiddleClick = null;
    void delegate() onRightClick = null;
    void delegate() onMouseInside = null;
    void delegate() onUpdate = null;

    bool isOnLeftClick;
    bool isOnMiddleClick;
    bool isOnRightClick;
    bool isOnMouseInside;
  }

  /**
   *
  **/
  this(string name, Frame frame) {
    super(name, frame);
  }

  /**
   *
  **/
  override void update() {
    clearAllBooleans();

    if (isMouseColliding()) {
      if (hasOnMouseInside()) {
        onMouseInside();
        isOnMouseInside = true;
      }

      if (hasOnLeftClick()) {
        if (Input.isMouseButtonDown(MouseButton.LEFT)) {
          onLeftClick();
          isOnLeftClick = true;
        }
      }

      if (hasOnMiddleClick()) {
        if (Input.isMouseButtonDown(MouseButton.MIDDLE)) {
          onMiddleClick();
          isOnMiddleClick = true;
        }
      }

      if (hasOnRightClick()) {
        if (Input.isMouseButtonDown(MouseButton.RIGHT)) {
          onRightClick();
          isOnRightClick = true;
        }
      }
    }

    if (onUpdate !is null)
      onUpdate();
  }

  /**
   *
  **/
  Button setOnLeftClick(void delegate() onLeftClick) pure nothrow {
    this.onLeftClick = onLeftClick;
    return this;
  }

  /**
   *
  **/
  Button setOnMiddleClick(void delegate() onMiddleClick) pure nothrow {
    this.onMiddleClick = onMiddleClick;
    return this;
  }

  /**
   *
  **/
  Button setOnRightClick(void delegate() onRightClick) pure nothrow {
    this.onRightClick = onRightClick;
    return this;
  }

  /**
   *
  **/
  Button setOnMouseInside(void delegate() onMouseInside) pure nothrow {
    this.onMouseInside = onMouseInside;
    return this;
  }

  /**
   *
  **/
  Button setOnUpdate(void delegate() onUpdate) pure nothrow {
    this.onUpdate = onUpdate;
    return this;
  }

  /**
   *
  **/
  bool hasOnLeftClick() pure nothrow const {
    return onLeftClick !is null;
  }

  /**
   *
  **/
  bool hasOnMiddleClick() pure nothrow const {
    return onMiddleClick !is null;
  }

  /**
   *
  **/
  bool hasOnRightClick() pure nothrow const {
    return onRightClick !is null;
  }

  /**
   *
  **/
  bool hasOnMouseInside() pure nothrow const {
    return onMouseInside !is null;
  }

  private void clearAllBooleans() {
    isOnLeftClick = false;
    isOnMiddleClick = false;
    isOnRightClick = false;
    isOnMouseInside = false;
  }

  private void clearAllEvents() {
    onLeftClick = null;
    onMiddleClick = null;
    onRightClick = null;
    onMouseInside = null;
  }
}