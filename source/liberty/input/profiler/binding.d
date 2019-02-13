/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/profiler/binding.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.profiler.binding;

import liberty.input.constants;
import liberty.input.impl;
import liberty.input.profiler.data;
import liberty.input.profiler.impl;
import liberty.input.joystick.impl;
import liberty.input.keyboard.impl;
import liberty.input.mouse.impl;

/**
 *
**/
final class InputActionBinding {
  private {
    string id;
    InputProfiler parent;
  }

  /**
   *
  **/
  InputAction!Keyboard[] keyboard;

  /**
   *
  **/
  InputAction!Mouse[] mouse;
  
  /**
   *
  **/
  InputAction!Joystick[] joystick;

  /**
   *
  **/
  this(string id, InputProfiler parent) {
    this.id = id;
    this.parent = parent;
  }

  /**
   *
  **/
  string getId()   const {
    return id;
  }

  /**
   *
  **/
  bool isUnfolding() {
    import std.uni : toLower;
    import std.traits : EnumMembers;
    
    static foreach (type; EnumMembers!InputDeviceType)
      static if (type != "None")
        foreach (e; mixin(type.toLower()))
          if (mixin("Input.get" ~ type ~ "().isUnfolding(e.button, e.action)")) {
            parent.lastDeviceUsed = type;
            return true;
          }

    return false;
  }
}

/**
 *
**/
final class InputAxisBinding {
  private {
    string id;
  }

  /**
   *
  **/
  InputAxis!Keyboard[] keyboard;

  /**
   *
  **/
  InputAxis!Mouse[] mouse;
  
  /**
   *
  **/
  InputAxis!Joystick[] joystick;

  /**
   *
  **/
  this(string id) {
    this.id = id;
  }

  /**
   *
  **/
  string getId()   const {
    return id;
  }
}