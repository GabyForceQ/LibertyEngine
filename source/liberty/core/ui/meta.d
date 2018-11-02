/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.meta;

import liberty.core.ui.events;
import liberty.core.ui.button;

/**
 *
**/
struct Signal(WIDGET) {
  /**
   *
  **/
  string id;

  static if (is(WIDGET == Button))
    /**
     *
    **/
    ButtonEvent event;
  else
    static assert (0, "Object " ~ WIDGET.stringof ~ " does not support signals.");
}

/**
 *
**/
immutable ListenerBody = q{
  protected void startListening() {
    import std.traits : hasUDA, getUDAs, getSymbolsByUDA;


    // Go through all members
    static foreach (member; __traits(derivedMembers, typeof(this)))
      // Go through all attributes of current member if exist
      static foreach (i; 0..getUDAs!(__traits(getMember, typeof(this), member), Signal).length)
        // Check if it is a button event
        static if (hasUDA!(__traits(getMember, typeof(this), member), Signal!Button)) {
          // Check if event is ButtonMouseLeft
          static if (getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].event == ButtonEvent.MouseLeftClick)
            (cast(Button)getWidget(getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].id))
              .setOnLeftClick(&mixin(member));

          // Check if event is ButtonMouseMiddle
          static if (getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].event == ButtonEvent.MouseMiddleClick)
            (cast(Button)getWidget(getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].id))
              .setOnMiddleClick(&mixin(member));

          // Check if event is ButtonMouseRight
          static if (getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].event == ButtonEvent.MouseRightClick)
            (cast(Button)getWidget(getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].id))
              .setOnRightClick(&mixin(member));

          // Check if event is ButtonMouseInside
          static if (getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].event == ButtonEvent.MouseInside)
            (cast(Button)getWidget(getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].id))
              .setOnMouseInside(&mixin(member));
        }
  }
};