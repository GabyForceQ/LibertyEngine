module liberty.mvc.objects.node.meta;

/**
 *
 */
immutable NodeBody = q{
    this(string id, Node parent = Logic.self.activeScene.tree) {
        if (parent is null) {
            assert(0, "Parent object cannot be null");
        }
        super(id, parent);
        import std.traits : hasUDA;
        enum finalClass = __traits(isFinalClass, this);
        enum abstractClass = __traits(isAbstractClass, this);
        static if (!(finalClass || abstractClass)) {
            static assert(0, "A node object class must either be final or abstract!");
        }
        static if (__traits(compiles, constructor)) {
            import std.traits : isMutable;
            static if (__traits(getProtection, constructor) != "private") {
                static assert (0, "constructor must be private");
            }
            static if (isMutable!(typeof(constructor))) {
                static assert (0, "constructor must be immutable or const");
            }
            mixin(constructor);
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