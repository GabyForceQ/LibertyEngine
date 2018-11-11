/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/ui/button.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.ui.button;

import std.traits : EnumMembers;

import liberty.meta;
import liberty.surface.ui.widget;
import liberty.surface.impl;
import liberty.input.impl;
import liberty.input.constants;

/**
 *
**/
final class Button : Widget {
  private {
    static foreach (member; EnumMembers!ButtonEvent) {
      mixin ("void delegate() on" ~ member ~ " = null;");
      
      static if (member != "Update")
        mixin ("bool isOn" ~ member ~ ";");
    }
  }

  /**
   *
  **/
  this(string name, Surface surface) {
    super(name, surface);
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

      if (hasOnMouseMove())
        if (Input.isMouseMoving()) {
          onMouseMove();
          isOnMouseMove = true;
        }

      if (hasOnMouseLeftClick())
        if (Input.isMouseButtonDown(MouseButton.LEFT)) {
          onMouseLeftClick();
          isOnMouseLeftClick = true;
        }

      if (hasOnMouseMiddleClick())
        if (Input.isMouseButtonDown(MouseButton.MIDDLE)) {
          onMouseMiddleClick();
          isOnMouseMiddleClick = true;
        }

      if (hasOnMouseRightClick())
        if (Input.isMouseButtonDown(MouseButton.RIGHT)) {
          onMouseRightClick();
          isOnMouseRightClick = true;
        }
    }

    if (onUpdate !is null)
      onUpdate();
  }

  static foreach (member; EnumMembers!ButtonEvent) {
    /**
     *
    **/
    mixin ("Button setOn" ~ member ~ "(void delegate() on" ~ member ~ ") pure nothrow {" ~
      "this.on" ~ member ~ " = on" ~ member ~ "; return this; }");

    static if (member != "Update")
      /**
       *
      **/
      mixin ("bool hasOn" ~ member ~ "() pure nothrow const {" ~
        "return on" ~ member ~ " !is null; }");
  }

  private void clearAllBooleans() {
    static foreach (member; EnumMembers!ButtonEvent)
      static if (member != "Update")
        mixin ("isOn" ~ member ~ " = false;");
  }

  private void clearAllEvents() {
    static foreach (member; EnumMembers!ButtonEvent)
      static if (member != "Update")
        mixin ("on" ~ member ~ " = null;");
  }
}

/**
 *
**/
enum ButtonEvent : string {
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
  MouseInside = "MouseInside",

  /**
   *
  **/
  MouseMove = "MouseMove",

  /**
   *
  **/
  Update = "Update"
}