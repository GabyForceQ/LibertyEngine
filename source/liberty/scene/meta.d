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
 *
**/
struct Component;

/**
 *
**/
mixin template NodeConstructor(string code = "") {
  import liberty.core.engine;
  import liberty.scene.node;

  /**
   *
  **/
  this(string id, SceneNode parent = CoreEngine.getScene().getTree()) {
    if (parent is null)
      assert(0, "Parent object cannot be null");

    super(id, parent);
    
    import std.traits : hasUDA;
    import std.string : capitalize;
    
    enum finalClass = __traits(isFinalClass, this);
    enum abstractClass = __traits(isAbstractClass, this);
    
    static if (!(finalClass || abstractClass))
      static assert(0, "A node object class must either be final or abstract!");

    mixin(code);

    static if (__traits(isFinalClass, this)) {
      static foreach (el; ["start", "update", "render"]) {
        static foreach (super_member; __traits(allMembers, typeof(super)))
          static if (super_member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "List(id, this);");
          
        static foreach (member; __traits(allMembers, typeof(this)))
          static if (member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene().set" ~ el.capitalize() ~ "List(id, this);");
      }
    }

    // *BUG*

    static if (typeof(this).stringof == "Terrain")
      getScene()
        .registerTerrain(this);

    static if (typeof(super).stringof == "Surface")
      getScene()
        .registerSurface(this);

    static if (typeof(super).stringof == "Primitive" || typeof(super).stringof == "BSPVolume")
      getScene()
        .getPrimitiveSystem()
        .registerPrimitive(this);

    static if (typeof(this).stringof == "PointLight")
      getScene()
        .getLightingSystem()
        .registerLight(this);

    // *END_BUG*
  }
}

/**
 *
**/
mixin template NodeDestructor(string code) {
  ~this() {
    mixin(code);
  }
}