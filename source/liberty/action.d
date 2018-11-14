/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/action.d)
 * Documentation:
 * Coverage:
 * TODO:
 *    - Change action priority and implement priority mechanism.
**/
module liberty.action;

import liberty.surface.ui.widget;

/**
 *
**/
final class Action(T) {
  private {
    string id;
    void delegate(T, Event) event;
    uint priority;
  }

  /**
   *
  **/
  this(string id, void delegate(T, Event) event, int priority) pure nothrow {
    this.id = id;
    this.event = event;
    this.priority = priority;
  }

  /**
   *
  **/
  Action!T callEvent(T sender, Event e) {
    event(sender, e);
    return this;
  }

  /**
   *
  **/
  Action!T changePriority(uint value) pure nothrow {
    priority = value; //
    return this;
  }

  /**
   *
  **/
  uint getPriority() pure nothrow const {
    return priority;
  }
}

alias UIAction = Action!Widget;