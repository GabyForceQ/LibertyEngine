/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/resource/manager.d, _manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.resource.manager;

import liberty.core.io.manager : IOManager;
import liberty.core.logger.manager : Logger;
import liberty.core.utils : Singleton;
import liberty.core.manager.meta : ManagerBody;
import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.graphics.texture.cache : TextureCache;
import liberty.graphics.texture.data : Texture;
import liberty.graphics.vertex : Vertex;
import liberty.world.components.mesh : Mesh;

/**
 *
**/
final class ResourceManager : Singleton!ResourceManager {
  mixin(ManagerBody);

  private {
    TextureCache _textureCache;
  }

  private static immutable startBody = q{
    _textureCache = new TextureCache();
  };

  /**
   *
  **/
  Texture getTexture(string resourcePath) {
    // Check if service is running
    if (checkService()) {
      return _textureCache.getTexture(resourcePath);
    }
    
    return Texture();
  }

  /**
   *
  **/
  Mesh loadMesh(string path) {
    import std.array : split;
    import std.conv : to;
    import std.stdio : File;

    // Check extension
    string[] splitArray = path.split(".");
    immutable ext = splitArray[$ - 1];
    if (ext != "obj") {
      Logger.self.error(
        "File format not supported for mesh data: " ~ ext,
        typeof(this).stringof
      );
    }

    Vertex[] vertices;
    int[] indices;

    // Open the file
    auto file = File(path);
    scope (exit) file.close();

    // Read the file and build mesh data
    auto range = file.byLine();
    foreach (line; range) {
      char[][] tokens = line.split(" ");
      
      if (tokens.length == 0 || tokens[0] == "#") {
        continue;
      } else if (tokens[0] == "v") {
        // It is a vertex
        vertices ~= Vertex(
          Vector3F(
            tokens[1].to!float,
            tokens[2].to!float,
            tokens[3].to!float
          ),
          Vector2F(
            1.0f, 1.0f
          )
        );
      } else if (tokens[0] == "f") {
        // It is an index
        indices ~= tokens[1].to!int - 1;
        indices ~= tokens[2].to!int - 1;
        indices ~= tokens[3].to!int - 1;
      }
    }

    // Create and fill a mesh with data
    Mesh res = new Mesh();
    res.addVertices(vertices, indices);

    return res;
  }
}