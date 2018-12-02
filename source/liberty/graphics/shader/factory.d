/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.factory;

import liberty.graphics.shader.constants;
import liberty.graphics.shader.graph;

/**
 *
**/
interface IGfxShaderFactory {
  private {
    static GfxShaderGraph[GfxShaderGraphDefaultType] defaultShaders;
  }

  /**
   *
  **/
  static GfxShaderGraph getDefaultShader(GfxShaderGraphDefaultType type) {
    if (type !in defaultShaders)
      final switch (type) with (GfxShaderGraphDefaultType) {
        case PRIMITIVE:
          // Create primitive shader
          defaultShaders[type] = new GfxShaderGraph();
          defaultShaders[type]
            .addVertexCode(mixin("q{" ~ import("shaders/primitive_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/primitive_fragment.glsl") ~ "}"))
            .build;

          break;
        case TERRAIN:
          // Create terrain shader
          defaultShaders[type] = new GfxShaderGraph();
          defaultShaders[type]
            .addVertexCode(mixin("q{" ~ import("shaders/terrain_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/terrain_fragment.glsl") ~ "}"))
            .build;

          break;
        case SKYBOX:
          // Create terrain shader
          defaultShaders[type] = new GfxShaderGraph();
          defaultShaders[type]
            .addVertexCode(mixin("q{" ~ import("shaders/skybox_vertex.glsl") ~ "}"))
            .addFragmentCode(mixin("q{" ~ import("shaders/skybox_fragment.glsl") ~ "}"))
            .build;

          break;
      }
    
    return defaultShaders[type];
  }
}