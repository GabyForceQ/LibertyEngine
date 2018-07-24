/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/meta.d, _meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.meta;

///
immutable ListenerBody = q{
	/// Starts current containing events and @Signal events.
	/// A @Signal event overrides a current containing event.
	void startListening(T)(ref T element) {
        import std.traits : hasUDA, getUDAs;
        if (!element._canListen) {
            element._canListen = true;
            if (typeof(element).stringof == Button.stringof) {
                mixin(ButtonListenerBody);
            }
        }
    }
    /// Clears all events. Restarts only @Signal events.
    void restartListening(T)(ref T element) {
        import std.traits : hasUDA, getUDAs;
        element.stopListening();
        element._canListen = true;
        if (typeof(element).stringof == Button.stringof) {
            mixin(ButtonListenerBody);
        }
    }
};
///
immutable WidgetListenerBody = q{
    static foreach (type; ["Update"]) {
        static if (type == getUDAs!(__traits(getMember, this, member), Event)[0].type) {
            if (element.id == getUDAs!(__traits(getMember, this, member), Signal)[0].id) {
                mixin("element.on" ~ type ~ " = &" ~ member ~ ";");
            }
        }
    }
};
///
immutable ButtonListenerBody = q{
	static if (typeof(super).stringof == "Canvas") {
		static foreach (member; __traits(derivedMembers, typeof(this))) {
			static if (mixin("hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Event)")
					&& mixin("hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Signal)")) {
				static foreach (type; ["MouseLeftClick", "MouseMiddleClick", "MouseRightClick", "MouseMove", "MouseInside"]) {
					static if (type == getUDAs!(__traits(getMember, this, member), Event)[0].type) {
						if (element.id == getUDAs!(__traits(getMember, this, member), Signal)[0].id) {
							mixin("element.on" ~ type ~ " = &" ~ member ~ ";");
                        }
					}
				}
                mixin(WidgetListenerBody);
			}
		}
	}
};