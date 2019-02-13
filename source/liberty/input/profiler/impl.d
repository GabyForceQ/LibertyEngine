/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/profiler/impl.d)
 * Documentation:
 * Coverage:
 * TODO:
 *  - axis
 *  - add shift, ctrl, alt, cmd to action mapping
**/
module liberty.input.profiler.impl;

import liberty.logger.impl;
import liberty.input.constants;
import liberty.input.profiler.binding;
import liberty.input.profiler.data;
import liberty.input.joystick.impl;
import liberty.input.keyboard.impl;
import liberty.input.mouse.impl;

/**
 *
**/
final class InputProfiler {
  private {
    string id;
    bool warnings = true;
    InputActionBinding[string] actionBindings;
    InputAxisBinding[string] axisBindings;

    InputAction!Joystick iacj_test;
    InputAction!Keyboard iack_test;
    InputAction!Mouse iacm_test;

    InputAxis!Joystick iaxj_test;
    InputAxis!Keyboard iaxk_test;
    InputAxis!Mouse iaxm_test;
  }

  package {
    InputDeviceType lastDeviceUsed = InputDeviceType.None;
  }

  /**
   *
  **/
  this(string id)   {
    this.id = id;
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
  InputProfiler createActionBinding(string id) {
    actionBindings[id] = new InputActionBinding(id, this);
    return this;
  }

  /**
   *
  **/
  InputProfiler createAxisBinding(string id) {
    return this;
  }

  /**
   *
  **/
  InputProfiler bindAction(T...)(string id, T actions)
  in (actions.length > 0)
  do {
    // If action with this id doesn't exist, then create it.
    if (id !in actionBindings)
      createActionBinding(id);

    bool exists;
    static foreach (a; actions) {
      static if (typeof(a).stringof == typeof(iack_test).stringof) {
        foreach (e; actionBindings[id].keyboard)
          if (e.button == a.button && e.action == a.action)
            exists = true;

        if (!exists)
          actionBindings[id].keyboard ~= a;
      } else static if (typeof(a).stringof == typeof(iacm_test).stringof) {
        foreach (e; actionBindings[id].mouse)
          if (e.button == a.button && e.action == a.action)
            exists = true;

        if (!exists)
          actionBindings[id].mouse ~= a;
      } else static if (typeof(a).stringof == typeof(iacj_test).stringof) {
        foreach (e; actionBindings[id].joystick)
          if (e.button == a.button && e.action == a.action)
            exists = true;

        if (!exists)
          actionBindings[id].joystick ~= a;
      }
      exists = false;
    }

    return this;
  }

  /**
   *
  **/
  InputProfiler bindAxis(T...)(string id, T axises)
  in (axises.length > 0)
  do {
    // If axis with this id doesn't exist, then create it.
    if (id !in axisBindings)
      createAxisBinding(id);


    return this;
  }

  /**
   *
  **/
  InputProfiler unbindAction(string id) {
    actionBindings.remove(id);
    return this;
  }

  /**
   *
  **/
  InputProfiler unbindAllActions() {
    actionBindings.destroy();
    return this;
  }

  /**
   *
  **/
  InputProfiler unbindAxis(string id) {
    axisBindings.remove(id);
    return this;
  }

  /**
   *
  **/
  InputProfiler unbindAllAxises() {
    axisBindings.destroy();
    return this;
  }

  /**
   *
  **/
  bool isActionUnfolding(string id) {
    if (id !in actionBindings) {
      if (warnings)
        Logger.warning("Action binding with id: '" ~ id ~ "' of profile with id: '"
          ~ this.id ~ "' doesn't exist. False will be returned.", typeof(this).stringof);
      return false;
    }

    return actionBindings[id].isUnfolding();
  }

  /**
   *
  **/
  InputDeviceType getLastDeviceUsed()   {
    return lastDeviceUsed;
  }

  /**
   *
  **/
  InputProfiler setWarningsEnabled(bool enabled = true)   {
    warnings = enabled;
    return this;
  }

  /**
   *
  **/
  bool areWarningsEnabled()   const {
    return warnings;
  }
}