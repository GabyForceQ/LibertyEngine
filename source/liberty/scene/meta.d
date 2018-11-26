/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.meta;

/**
 * The scene node default constructor.
 * You can send a string code with the construction code.
 * See $(D SceneNode).
**/
mixin template NodeConstructor(string code = "") {
  import liberty.core.engine : CoreEngine;
  import liberty.scene.node : SceneNode;

  /**
   * The default constructor of a scene node.
   * See $(D SceneNode).
  **/
  this(string id, SceneNode parent = CoreEngine.getScene().getTree()) {
    import std.traits : hasUDA, EnumMembers;
    import std.string : capitalize;
    import liberty.constants : SystemType;
    import liberty.cubemap.impl : CubeMap;
    import liberty.light.point : Lighting;
    import liberty.primitive.impl : Primitive;
    import liberty.surface.impl : Surface;
    import liberty.terrain.impl : Terrain;
    import liberty.text.impl : Text;

    if (parent is null)
      assert(0, "Parent object cannot be null");

    super(id, parent);
    
    enum finalClass = __traits(isFinalClass, this);
    enum abstractClass = __traits(isAbstractClass, this);
    
    static if (!(finalClass || abstractClass))
      static assert(0, "A node object class must either be final or abstract!");

    mixin(code);

    static if (__traits(isFinalClass, this)) {
      static foreach (el; ["start", "update"]) {
        static foreach (super_member; __traits(allMembers, typeof(super)))
          static if (super_member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "ableMap(id, this);");
          
        static foreach (member; __traits(allMembers, typeof(this)))
          static if (member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "ableMap(id, this);");
      }
    }

    static foreach (sys; EnumMembers!SystemType)
      static if (mixin("is(typeof(this) : " ~ sys ~ ")"))
        mixin("getScene().get" ~ sys ~ "System().registerElement(this);");
  }
}

/**
 * The scene node default constructor.
 * You can send a string code with the destruction code.
 * See $(D SceneNode).
**/
mixin template NodeDestructor(string code) {
  ~this() {
    mixin(code);
  }
}