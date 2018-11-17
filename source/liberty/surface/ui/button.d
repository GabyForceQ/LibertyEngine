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
import liberty.input.mouse.constants;

/**
 *
**/
final class Button : Widget {
  private {
    static foreach (member; EnumMembers!ButtonEvent) {
      mixin ("void delegate(Widget, Event) on" ~ member ~ " = null;");
      
      static if (member != "Update")
        mixin ("bool isOn" ~ member ~ ";");
    }

    bool mouseEntered;
  }

  /**
   *
  **/
  this(string id, Surface surface) {
    super(id, surface);
  }

  /**
   *
  **/
  override void update() {
    clearAllBooleans();

    if (Input.getMouse().getCursorType() != CursorType.DISABLED) {
      if (isMouseColliding()) {
        if (hasOnMouseOver()) {
          onMouseOver(this, Event.MouseOver);
          isOnMouseOver = true;
        }

        if (hasOnMouseMove())
          if (Input.getMouse().isMoving()) {
            onMouseMove(this, Event.MouseMove);
            isOnMouseMove = true;
          }

        if (hasOnMouseEnter() && !mouseEntered) {
          onMouseEnter(this, Event.MouseEnter);
          mouseEntered = true;
          isOnMouseEnter = true;
        }

        if (hasOnMouseLeftClick())
          if (Input.getMouse().isButtonDown(MouseButton.LEFT)) {
            onMouseLeftClick(this, Event.MouseLeftClick);
            isOnMouseLeftClick = true;
          }

        if (hasOnMouseMiddleClick())
          if (Input.getMouse().isButtonDown(MouseButton.MIDDLE)) {
            onMouseMiddleClick(this, Event.MouseMiddleClick);
            isOnMouseMiddleClick = true;
          }

        if (hasOnMouseRightClick())
          if (Input.getMouse().isButtonDown(MouseButton.RIGHT)) {
            onMouseRightClick(this, Event.MouseRightClick);
            isOnMouseRightClick = true;
          }
      } else if (hasOnMouseLeave() && mouseEntered) {
        onMouseLeave(this, Event.MouseLeave);
        mouseEntered = false;
        isOnMouseLeave = true;
      }
    }

    if (onUpdate !is null)
      onUpdate(this, Event.Update);
  }

  static foreach (member; EnumMembers!ButtonEvent) {
    /**
     *
    **/
    mixin ("Button setOn" ~ member ~ "(void delegate(Widget, Event) on" ~ member ~ ") pure nothrow {" ~
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
  MouseOver = "MouseOver",

  /**
   *
  **/
  MouseMove = "MouseMove",

  /**
   *
  **/
  MouseEnter = "MouseEnter",

  /**
   *
  **/
  MouseLeave = "MouseLeave",

  /**
   *
  **/
  Update = "Update"
}