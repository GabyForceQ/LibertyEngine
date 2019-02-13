/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.io;

import liberty.model.data;
import liberty.graphics.buffer;

/**
 *
**/
final abstract class ModelIO {
  /// Load a raw model into memory using vertex data.
  /// Returns newly created raw model.
  static RawModel loadRawModel(VERTEX)(VERTEX[] data) {
    // Create vertex array object for the model    
    GfxVertexArray vao = GfxVertexArray.createArray;
    vao.appendToVAOs(vao.handle);

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxBuffer.createBuffer(GfxBufferTarget.ARRAY, GfxDataUsage.STATIC_DRAW, data);    
    vbo.appendToVBOs(vbo.handle);

    // Bind vertex attribute pointer
    VERTEX.bindAttributePointer;
    
    // Unbind vertex buffer object
    vbo.unbind;

    // Unbind vertex array object
    vao.unbind;

    return RawModel(vao.handle, data.length, false);
  }

  /// Load a raw model into memory using vertex data and indices.
  /// Indices are stored into the internal vertex buffer object static array.
  /// Returns newly created raw model.
  static RawModel loadRawModel(VERTEX)(VERTEX[] data, uint[] indices) {
    // Create vertex array object for the model
    GfxVertexArray vao = GfxVertexArray.createArray();
    vao.appendToVAOs(vao.handle);

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxBuffer.createBuffer(GfxBufferTarget.ARRAY, GfxDataUsage.STATIC_DRAW, data);
    vbo.appendToVBOs(vbo.handle);

    // Create element buffer object for the model
    // This shouldn't be unbinded
    GfxBuffer ebo = GfxBuffer.createBuffer(GfxBufferTarget.ELEMENT_ARRAY, GfxDataUsage.STATIC_DRAW, indices);
    ebo.appendToVBOs(ebo.handle);

    // Bind vertex attribute pointer
    VERTEX.bindAttributePointer;
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();
    
    return RawModel(vao.handle, indices.length, true);
  }

  /**
   * Load a model into memory using a file with .obj extension.
   * Indices are stored into the internal vertex buffer object static array.
   * Returns newly created model.
  **/
  static Model loadModel(VERTEX)(string path) {
    import std.array : split;

    // Check extension
    string[] splitArray = path.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "obj":
        return loadOBJFile!VERTEX(path);
      default:
        Logger.error(	
          "File format not supported for mesh data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
  }

  private static Model loadOBJFile(VERTEX)(string path) {
    VERTEX[] vertices;	

    Vector3F[] positions;
    Vector3F[] normals;
    Vector2F[] uvs;

    Vector3F[] tmpPositions;
    Vector3F[] tmpNormals;
    Vector2F[] tmpUvs;

    uint[] vertexIndices;
    uint[] normalIndices;
    uint[] uvIndices;
    
    // Open the file
    auto file = File(path);
    scope(exit) file.close();

    // Read the file and build mesh data
    auto range = file.byLine();
    foreach (line; range) {
      line = line.strip();
      char[][] tokens = line.split(" ");

      if (tokens.length == 0 || tokens[0] == "#") {	
        continue;
      } else if (tokens[0] == "v") {
        tmpPositions ~= Vector3F(tokens[1].to!float, tokens[2].to!float, tokens[3].to!float);   
      } else if (tokens[0] == "vn") {
        tmpNormals ~= Vector3F(tokens[1].to!float, tokens[2].to!float, tokens[3].to!float);
      } else if (tokens[0] == "vt") {
        tmpUvs ~= Vector2F(tokens[1].to!float, tokens[2].to!float);
      } else if (tokens[0] == "f") {
        uint v1, v2, v3, v4;
        uint t1, t2, t3, t4;
        uint n1, n2, n3, n4;

        char[256] tmpLine;
        tmpLine[0..line.length] = line[];
        tmpLine[line.length] = 0;

        if (sscanf(line.ptr, "f %u/%u/%u %u/%u/%u %u/%u/%u %u/%u/%u", &v1, &t1, &n1, &v2, &t2, &n2, &v3, &t3, &n3, &v4, &t4, &n4) == 12) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
          
          uvIndices ~= t1 - 1;
          uvIndices ~= t2 - 1;
          uvIndices ~= t3 - 1;
          
          normalIndices ~= n1-1;
          normalIndices ~= n2-1;
          normalIndices ~= n3-1;
        } else if (sscanf(line.ptr, "f %u/%u/%u %u/%u/%u %u/%u/%u", &v1, &t1, &n1, &v2, &t2, &n2, &v3, &t3, &n3) == 9) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
        
          uvIndices ~= t1 - 1;
          uvIndices ~= t2 - 1;
          uvIndices ~= t3 - 1;
        
          normalIndices ~= n1 - 1;
          normalIndices ~= n2 - 1;
          normalIndices ~= n3 - 1;
        } else if (sscanf(line.ptr, "f %u//%u %u//%u %u//%u %u//%u", &v1, &n1, &v2, &n2, &v3, &n3, &v4, &n4) == 8) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
          
          normalIndices ~= n1-1;
          normalIndices ~= n2-1;
          normalIndices ~= n3-1;
        } else if (sscanf(line.ptr, "f %u/%u %u/%u %u/%u", &v1, &t1, &v2, &t2, &v3, &t3) == 6) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
          
          uvIndices ~= t1 - 1;
          uvIndices ~= t2 - 1;
          uvIndices ~= t3 - 1;
        } else if (sscanf(line.ptr, "f %u//%u %u//%u %u//%u", &v1, &n1, &v2, &n2, &v3, &n3) == 6) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
          
          normalIndices ~= n1 - 1;
          normalIndices ~= n2 - 1;
          normalIndices ~= n3 - 1;
        } else if (sscanf(line.ptr, "f %u %u %u %u", &v1, &v2, &v3, &v4) == 4) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
        } else if (sscanf(line.ptr, "f %u %u %u", &v1, &v2, &v3) == 3) {
          vertexIndices ~= v1 - 1;
          vertexIndices ~= v2 - 1;
          vertexIndices ~= v3 - 1;
        } else {
          Logger.error("Unreachable", "ResourceManager: loadOBJFile");
        }
      }
    }

    foreach (i; 0..vertexIndices.length) {
      positions ~= tmpPositions[vertexIndices[i]];
      normals ~= tmpNormals[normalIndices[i]];
      uvs ~= tmpUvs[uvIndices[i]];

      vertices ~= VERTEX(positions[i], normals[i], uvs[i]);
    }

    return new Model(loadRawModel(vertices), [Material.getDefault()]);
  }
}