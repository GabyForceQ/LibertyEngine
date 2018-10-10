/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/node/meta.d)
 * Documentation:
 * Coverage:
 *
 *  TODO:
 *    - add "process" to list
**/
module liberty.core.objects.meta;

/**
 *
**/
immutable NodeBody = q{
  import liberty.core.engine : CoreEngine;
  import liberty.core.objects.node : WorldObject;

  this(string id, WorldObject parent = CoreEngine.getScene().getTree()) {
    if (parent is null)
      assert(0, "Parent object cannot be null");

    super(id, parent);
    
    import std.traits : hasUDA;
    import std.string : capitalize;
    
    enum finalClass = __traits(isFinalClass, this);
    enum abstractClass = __traits(isAbstractClass, this);
    
    static if (!(finalClass || abstractClass))
      static assert(0, "A node object class must either be final or abstract!");

    static if (__traits(compiles, constructor))
      constructor();

    static if (__traits(isFinalClass, this)) {
      static foreach (el; ["start", "update", "render"]) {
        static foreach (super_member; __traits(derivedMembers, typeof(super)))
          static if (super_member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "List(id, this);");
          
        static foreach (member; __traits(derivedMembers, typeof(this)))
          static if (member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "List(id, this);");
      }
    }
  }
};