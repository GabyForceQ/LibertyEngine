/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.meta;

import liberty.framework.gui.widget;

/**
 *
**/
mixin template WidgetEventProps(alias event, string options = "default") {
  static string[] getEventArrayString()   {
    return event;
  }

  static if (options == "default") {
    import std.algorithm : canFind;
    import std.traits : EnumMembers;

    private {
      static foreach (name; EnumMembers!Event)
        mixin("enum bool _" ~ name ~ " = getEventArrayString.canFind(Event." ~ name ~ ");");
      
      enum bool _MouseEnterLeave = _MouseEnter && _MouseLeave;
      enum bool _CheckUncheck = _Check && _Uncheck && _Checked && _Unchecked && _StateChange;

      static if (_MouseEnterLeave)
        bool mouseEntered;

      static if (_CheckUncheck) {
        bool checked;
        
        public bool isChecked()   const {
          return checked;
        }
      }

      static if (_StateChange)
        bool state;

      static foreach (member; event) {
        mixin("void delegate(Widget, Event) on" ~ member ~ " = null;");

        static if (member != "Update")
          mixin("bool isOn" ~ member ~ ";");
      }
    }

    static if (_MouseEnter || _MouseLeave)
      static assert(_MouseEnterLeave,
        "In default mode MouseEnter and MouseLeave events should be declared together.");

    static if (_Check || _Uncheck || _Checked || _Unchecked)
      static assert(_CheckUncheck,
        "In default mode Check, Uncheck, Checked and Unchecked events should be declared together.");

    static foreach (member; event) {
      /**
      *
      **/
      mixin("typeof(this) setOn" ~ member ~ "(void delegate(Widget, Event) on" ~ member ~ ")   {" ~
        "this.on" ~ member ~ " = on" ~ member ~ "; return this; }");

      static if (member != "Update")
        /**
        *
        **/
        mixin("bool hasOn" ~ member ~ "()   const {" ~
          "return on" ~ member ~ " !is null; }");
    }
    
    private void clearAllBooleans() {
      static foreach (member; event)
        static if (member != "Update")
          mixin("isOn" ~ member ~ " = false;");
    }

    private void clearAllEvents() {
      static foreach (member; event)
        static if (member != "Update")
          mixin("on" ~ member ~ " = null;");
    }
  } else static if (options == "custom") {
    
  } else
    static assert(0, "Invalid options.");
}

/**
 *
**/
mixin template WidgetConstructor(string code = "") {
  import liberty.framework.gui.impl;
  
  /**
   *
  **/
  this(string id, Gui gui) {
    super(id, gui);
    mixin(code);
  }
}

/**
 *
**/
mixin template WidgetUpdate() {
  import liberty.input.impl;
  import liberty.input.mouse.constants;
  
  /**
   *
  **/
  override void update() {
    clearAllBooleans();

    static if (_StateChange)
      state = false;

    if (Input.getMouse.getCursorType != CursorType.DISABLED) {
      if (isMouseColliding) {
        static if (_MouseOver)
          if (hasOnMouseOver) {
            onMouseOver(this, Event.MouseOver);
            isOnMouseOver = true;
          }

        static if (_MouseMove)
          if (hasOnMouseMove)
            if (Input.getMouse.isMoving) {
              onMouseMove(this, Event.MouseMove);
              isOnMouseMove = true;
            }

        static if (_MouseEnterLeave) {
          if (hasOnMouseLeave && !hasOnMouseEnter) {
            if (!mouseEntered)
              mouseEntered = true;
          } else if (hasOnMouseEnter && !mouseEntered) {
            onMouseEnter(this, Event.MouseEnter);
            mouseEntered = true;
            isOnMouseEnter = true;
          }
        }

        static if (_MouseLeftClick)
          if (hasOnMouseLeftClick)
            if (Input.getMouse.isButtonDown(MouseButton.LEFT)) {
              onMouseLeftClick(this, Event.MouseLeftClick);
              isOnMouseLeftClick = true;
            }

        static if (_MouseMiddleClick)
          if (hasOnMouseMiddleClick)
            if (Input.getMouse.isButtonDown(MouseButton.MIDDLE)) {
              onMouseMiddleClick(this, Event.MouseMiddleClick);
              isOnMouseMiddleClick = true;
            }

        static if (_MouseRightClick)
          if (hasOnMouseRightClick)
            if (Input.getMouse.isButtonDown(MouseButton.RIGHT)) {
              onMouseRightClick(this, Event.MouseRightClick);
              isOnMouseRightClick = true;
            }

        static if (_CheckUncheck) {
          if (hasOnCheck && !checked) {
            if (Input.getMouse.isButtonDown(MouseButton.LEFT)) {
              onCheck(this, Event.Check);
              checked = true;
              isOnCheck = true;
              static if (_StateChange)
                state = true;
            }
          } else if (hasOnUncheck && checked)
            if (Input.getMouse.isButtonDown(MouseButton.LEFT)) {
              onUncheck(this, Event.Uncheck);
              checked = false;
              isOnUncheck = true;
              static if (_StateChange)
                state = true;
            }

          static if (_StateChange)
            if (hasOnStateChange && state) {
              onStateChange(this, Event.StateChange);
              isOnStateChange = true;
            }
        }
      } else {
        static if (_MouseLeave) {
          if (hasOnMouseLeave && mouseEntered) {
            onMouseLeave(this, Event.MouseLeave);
            isOnMouseLeave = true;
          }

          if (mouseEntered)
            mouseEntered = false;
        }
      }
    }

    static if (_CheckUncheck) {
      if (hasOnChecked && checked) {
        onChecked(this, Event.Checked);
        isOnChecked = true;
      } else if (hasOnUnchecked && !checked) {
        onUnchecked(this, Event.Unchecked);
        isOnUnchecked = true;
      }
    }

    static if (_Update)
      if (onUpdate !is null)
        onUpdate(this, Event.Update);
  }
}