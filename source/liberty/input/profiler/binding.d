/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/profiler/binding.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.profiler.binding;

import liberty.input.impl;
import liberty.input.profiler.data;
import liberty.input.joystick.impl;
import liberty.input.keyboard.impl;
import liberty.input.mouse.impl;

/**
 *
**/
final class InputActionBinding {
  private {
    string id;
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
  this(string id) {
    this.id = id;
  }

  /**
   *
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   *
  **/
  bool isUnfolding() {
    import std.string : capitalize;
    
    static foreach (type; ["mouse", "keyboard", "joystick"])
      foreach (e; mixin(type))
        if (mixin("Input.is" ~ type.capitalize() ~ "Action(e.button, e.action)"))
          return true;

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
  string getId() pure nothrow const {
    return id;
  }
}