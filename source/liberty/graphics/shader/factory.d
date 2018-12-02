/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.factory;

import liberty.graphics.shader.graph;

/**
 *
**/
interface IGfxShaderFactory {
  private {
    static GfxShaderGraph[string] defaultShaders;
  }

  /**
   *
  **/
  static GfxShaderGraph getShader(string id) {
    if (id !in defaultShaders)
      switch (id) {
        case "Primitive":
          // Create primitive shader
          defaultShaders[id] = new GfxShaderGraph(id);
          defaultShaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/primitive_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/primitive_fragment.glsl") ~ "}"))
            .build;

          break;
        case "SkyBox":
          // Create terrain shader
          defaultShaders[id] = new GfxShaderGraph(id);
          defaultShaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/skybox_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/skybox_fragment.glsl") ~ "}"))
            .build;

          break;
        case "Terrain":
          // Create terrain shader
          defaultShaders[id] = new GfxShaderGraph(id);
          defaultShaders[id]
            .addVertexCode(mixin("q{" ~ import("shaders/terrain_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/terrain_fragment.glsl") ~ "}"))
            .build;

          break;
        default:
          // TODO. Custom shaders.
          break;
      }
    
    return defaultShaders[id];
  }
}