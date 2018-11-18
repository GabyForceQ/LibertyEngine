/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.meta;

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
            static foreach (j; mixin(ui ~ ".getEventArrayString()"))
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

    static if (getEventArrayString().canFind(Event.MouseEnter) || getEventArrayString().canFind(Event.MouseLeave))
      private bool mouseEntered;

    static foreach (member; event) {
      mixin("private void delegate(Widget, Event) on" ~ member ~ " = null;");
      
      static if (member != "Update")
        mixin("private bool isOn" ~ member ~ ";");
    }

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
mixin template WidgetConstructor(string options = "renderer: enabled") {
  import liberty.surface.impl;
  
  /**
   *
  **/
  this(string id, Surface surface) {
    static if (options == "renderer: enabled")
      super(id, surface, true);
    else static if (options == "renderer: disabled")
      super(id, surface, false);
    else
      static assert(0, "Invalid options.");
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

    if (Input.getMouse().getCursorType() != CursorType.DISABLED) {
      if (isMouseColliding()) {
        static if (getEventArrayString().canFind(Event.MouseOver))
          if (hasOnMouseOver()) {
            onMouseOver(this, Event.MouseOver);
            isOnMouseOver = true;
          }

        static if (getEventArrayString().canFind(Event.MouseMove))
          if (hasOnMouseMove())
            if (Input.getMouse().isMoving()) {
              onMouseMove(this, Event.MouseMove);
              isOnMouseMove = true;
            }

        static if (getEventArrayString().canFind(Event.MouseEnter))
          if (hasOnMouseEnter() && !mouseEntered) {
            onMouseEnter(this, Event.MouseEnter);
            mouseEntered = true;
            isOnMouseEnter = true;
          }

        static if (getEventArrayString().canFind(Event.MouseLeftClick))
          if (hasOnMouseLeftClick())
            if (Input.getMouse().isButtonDown(MouseButton.LEFT)) {
              onMouseLeftClick(this, Event.MouseLeftClick);
              isOnMouseLeftClick = true;
            }

        static if (getEventArrayString().canFind(Event.MouseMiddleClick))
          if (hasOnMouseMiddleClick())
            if (Input.getMouse().isButtonDown(MouseButton.MIDDLE)) {
              onMouseMiddleClick(this, Event.MouseMiddleClick);
              isOnMouseMiddleClick = true;
            }

        static if (getEventArrayString().canFind(Event.MouseRightClick))
          if (hasOnMouseRightClick())
            if (Input.getMouse().isButtonDown(MouseButton.RIGHT)) {
              onMouseRightClick(this, Event.MouseRightClick);
              isOnMouseRightClick = true;
            }
      } else {
        static if (getEventArrayString().canFind(Event.MouseLeave))
          if (hasOnMouseLeave() && mouseEntered) {
            onMouseLeave(this, Event.MouseLeave);
            mouseEntered = false;
            isOnMouseLeave = true;
          }
      }
    }

    static if (getEventArrayString().canFind(Event.Update))
      if (onUpdate !is null)
        onUpdate(this, Event.Update);
  }
}