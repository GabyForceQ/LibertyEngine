/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/ui/meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.ui.meta;

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
immutable ListenerBody = q{
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
            static foreach (j; mixin("EnumMembers!" ~ ui ~ "Event"))
              // Check if event is defined
              static if (getUDAs!(__traits(getMember, typeof(this), member), mixin("Signal!" ~ ui))[i].event == j)
                // Register the event to the engine
                mixin ("(cast(" ~ ui ~ ")getWidget(getUDAs!(__traits(getMember, typeof(this), member),
                  mixin(`Signal!` ~ ui))[i].id)).setOn" ~ j ~ "(&mixin (member));");
  }
};