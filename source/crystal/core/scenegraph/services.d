/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.scenegraph.services;
///
immutable NodeServices = q{
    this(string id, Node parent = CoreEngine.getActiveScene().tree) {
        if (parent is null) {
            assert(0, "Parent object cannot be null");
        }
        super(id, parent);
        import std.traits: hasUDA;
        enum finalClass = __traits(isFinalClass, this);
        enum abstractClass = __traits(isAbstractClass, this);
        static if (!(finalClass || abstractClass)) {
            static assert(0, "A node object class must either be final or abstract!");
        }
        static foreach (i, member; __traits(derivedMembers, typeof(this))) {
            static if (mixin("hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Constructor)")) {
                enum accessFun = __traits(getProtection, __traits(getMember, this, member));
                enum finalFun = __traits(isFinalFunction, __traits(getMember, this, member));
                enum abstractFun = __traits(isAbstractFunction, __traits(getMember, this, member));
                static if (accessFun == "private" || accessFun == "protected") {
                    static if ((!finalFun || finalClass) && !abstractFun) {
	                    static if (member.stringof == "\"_\"") {
	                        mixin(member ~ "();");
	                    } else {
	                        static assert(0, "NodeObject's constructor must be named '_'!");
	                    }
	                } else {
	                    static assert(0, "NodeObject's constructor cannot be final or abstract!");
	                }
                } else {
                    static assert(0, "NodeObject's constructor must be private or protected!");
                }
            }
        }
	    static if (__traits(isFinalClass, this)) {
	        static foreach (el; ["start", "update", "process", "render"]) {
	            static foreach (super_member; __traits(derivedMembers, typeof(super))) {
                    static if (super_member.stringof == "\"" ~ el ~ "\"") {
                        mixin("scene." ~ el ~ "List[id] = this;");
                    }
                }
	            static foreach (member; __traits(derivedMembers, typeof(this))) {
	                static if (member.stringof == "\"" ~ el ~ "\"") {
	                    mixin("scene." ~ el ~ "List[id] = this;");
	                }
	            }
	        }
        }
    }
};
///
immutable ListenerServices = q{
	/// Starts current containing events and @Signal events.
	/// A @Signal event overrides a current containing event.
	void startListening(T)(ref T element) {
        import std.traits: hasUDA, getUDAs;
        if (!element.canListen()) {
            element.__setCanListen(true);
            if (typeof(element).stringof == Button.stringof) {
                mixin(ButtonListenerServices);
            }
        }
    }
    /// Clears all events. Restarts only @Signal events.
    void restartListening(T)(ref T element) {
        import std.traits: hasUDA, getUDAs;
        element.stopListening();
        element.__setCanListen(true);
        if (typeof(element).stringof == Button.stringof) {
            mixin(ButtonListenerServices);
        }
    }
};
///
immutable ButtonListenerServices = q{
	static foreach (member; __traits(derivedMembers, typeof(this))) {
        static if (typeof(super).stringof == "Canvas") {
            static if (mixin("hasUDA!(" ~ typeof(this).stringof ~ "." ~ member ~ ", Signal)")) {
                static foreach (el; ["RightClick", "LeftClick", "MouseMove", "MouseInside", "Update"]) {
                    static if (member.stringof == "\"on" ~ el ~ getUDAs!(__traits(getMember, this, member), Signal)[0].id ~ "\"") {
                        if (element.id == getUDAs!(__traits(getMember, this, member), Signal)[0].id) {
                            mixin("element.on" ~ el ~ " = &on" ~ el ~ getUDAs!(__traits(getMember, this, member), Signal)[0].id ~ ";");
                        }
                    }
                }
            }
        }
    }
};
///
struct Constructor;
///
struct Signal {
	string id;
}
///
interface Startable {
	///
	void start();
}
///
interface Updatable {
	///
	void update(float deltaTime);
}
///
interface Processable {
	///
	void process();
}