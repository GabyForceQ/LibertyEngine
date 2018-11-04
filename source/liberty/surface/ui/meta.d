/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/ui/meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.ui.meta;

import liberty.surface.ui.button;

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
    import std.traits : hasUDA, getUDAs, EnumMembers;

    // Go through all members
    static foreach (member; __traits(derivedMembers, typeof(this)))
      // Go through all attributes of current member if exist
      static foreach (i; 0..getUDAs!(__traits(getMember, typeof(this), member), Signal).length)
        // Check if it is a button event
        static if (hasUDA!(__traits(getMember, typeof(this), member), Signal!Button))
          // Go through all button events
          static foreach (j; EnumMembers!ButtonEvent)
            // Check if event is defined
            static if (getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].event == j)
              // Register the event to the engine
              mixin ("(cast(Button)getWidget(getUDAs!(__traits(getMember, typeof(this), member), Signal!Button)[i].id))
                .setOn" ~ j ~ "(&mixin (member));");
  }
};