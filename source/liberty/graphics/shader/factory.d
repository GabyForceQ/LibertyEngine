/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.factory;

import liberty.graphics.shader.impl;

/**
 *
**/
interface IShaderFactory {
  private {
    static Shader[string] shaders;
  }

  /**
   *
  **/
  static Shader getOrCreate(string id, void delegate(Shader) createDg = null) {
    if (id !in shaders) {
      switch (id) {
        case "Primitive":
          // Create primitive shader
          shaders[id] = new Shader(id);
          shaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/primitive_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/primitive_fragment.glsl") ~ "}"))
            .build;

          break;
        case "SkyBox":
          // Create terrain shader
          shaders[id] = new Shader(id);
          shaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/skybox_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/skybox_fragment.glsl") ~ "}"))
            .build;

          break;
        case "Terrain":
          // Create terrain shader
          shaders[id] = new Shader(id);
          shaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/terrain_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/terrain_fragment.glsl") ~ "}"))
            .build;

          break;
        case "Gui":
          // Create terrain shader
          shaders[id] = new Shader(id);
          shaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/gui_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/gui_fragment.glsl") ~ "}"))
            .build;

          break;
        default:
          // TODO. Custom shaders.
          break;
      }

      if (createDg !is null)
        createDg(shaders[id]);
    }
    
    return shaders[id];
  }
}