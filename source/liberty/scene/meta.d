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
    import std.string : capitalize;
    import liberty.framework.gui.impl : Gui;
    import liberty.framework.gui.renderer : GuiRenderer;
    import liberty.framework.light.impl : Light;
    import liberty.framework.light.renderer : LightRenderer;
    import liberty.framework.primitive.impl : Primitive;
    import liberty.framework.skybox.impl : SkyBox;
    import liberty.framework.skybox.renderer : SkyBoxRenderer;
    import liberty.framework.terrain.impl : Terrain;
    import liberty.framework.terrain.renderer : TerrainRenderer;
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
            mixin("getScene.set" ~ el.capitalize() ~ "ableMap(id, this);");
          
        static foreach (member; __traits(allMembers, typeof(this)))
          static if (member.stringof == "\"" ~ el ~ "\"")
            mixin("getScene.set" ~ el.capitalize() ~ "ableMap(id, this);");
      }
    }

    static foreach (sys; ["Terrain", "SkyBox", "Light", "Gui"])
      static if (mixin("is(typeof(this) : " ~ sys ~ ")"))
        mixin("(cast(" ~ sys ~ "Renderer)getScene.getOldRendererById(\"" ~ sys ~ "\")).registerElement(this);");
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

/**
 *
**/
mixin template RendererConstructor(string code = "") {
  import liberty.scene.impl : Scene;
  
  this(string id, Scene scene) {
    super(id, scene);
    mixin(code);
  }
}