/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.meta;

import liberty.surface.widget;

/**
 *
**/
struct Signal(WIDGET) {
  /**
   *
  **/
  string id;

  /**
   *
  **/
  string event;
}

/**
 *
**/
mixin template ListenerBody() {
  protected void startListening() {
    import std.traits : hasUDA, getUDAs, EnumMembers;

    // Go through all members
    static foreach (member; __traits(derivedMembers, typeof(this)))
      // Go through all attributes of current member if exist
      static foreach (i; 0..getUDAs!(__traits(getMember, typeof(this), member), Signal).length)
        // Go through all ui elements
        static foreach (ui; EnumMembers!WidgetType)
          // Check if it is a specific ui event
          static if (hasUDA!(__traits(getMember, typeof(this), member), mixin("Signal!" ~ ui)))
            // Go through all specific ui events
            static foreach (j; mixin(ui ~ ".getEventArrayString"))
              // Check if event is defined
              static if (getUDAs!(__traits(getMember, typeof(this), member), mixin("Signal!" ~ ui))[i].event == j)
                // Register the event to the engine
                mixin("(cast(" ~ ui ~ ")getWidget(getUDAs!(__traits(getMember, typeof(this), member),
                  mixin(`Signal!` ~ ui))[i].id)).setOn" ~ j ~ "(&mixin(member));");
  }
}

/**
 *
**/
mixin template WidgetEventProps(alias event, string options = "default") {
  static string[] getEventArrayString() pure nothrow {
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
        
        public bool isChecked() pure nothrow const {
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
      mixin("typeof(this) setOn" ~ member ~ "(void delegate(Widget, Event) on" ~ member ~ ") pure nothrow {" ~
        "this.on" ~ member ~ " = on" ~ member ~ "; return this; }");

      static if (member != "Update")
        /**
        *
        **/
        mixin("bool hasOn" ~ member ~ "() pure nothrow const {" ~
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
  import liberty.surface.impl;
  
  /**
   *
  **/
  this(string id, Surface surface) {
    super(id, surface);
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