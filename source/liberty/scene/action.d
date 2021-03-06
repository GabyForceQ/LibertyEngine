/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/action.d)
 * Documentation:
 * Coverage:
 * TODO:
 *    - Change action priority and implement priority mechanism.
**/
module liberty.scene.action;

import liberty.logger.impl;
import liberty.framework.gui.event;
import liberty.framework.gui.widget;

/// An action is represented by an id, an event and a priority.
final class Action(T) {
  private {
    static bool[string] idList;
    // callEvent
    void delegate(T, Event) event;
  }

  ///
  string id;
  ///
  ubyte priority;

  /// Create a new action specifying the id, event callback and priority.
  /// Id must be unique otherwise a logger error is thrown.
  /// Priority must be in range 0..255.
  this(string id, void delegate(T, Event) event, ubyte priority) {
    if (id in idList)
      Logger.error("Cannot create actions with the same id: " ~ id, typeof(this).stringof);
    idList[id] = true;
    this.id = id;
    this.event = event;
    this.priority = priority;
  }

  /// Remove the id from the id list.
  ~this() {
    idList.remove(id);
  }

  /// Call the action registered event.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) callEvent(T sender, Event e) {
    event(sender, e);
    return this;
  }
}