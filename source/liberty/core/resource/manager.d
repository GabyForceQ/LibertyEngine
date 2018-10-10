/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/resource/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *    - no opengl code here
**/
module liberty.core.resource.manager;

version (__OPENGL__)
  import derelict.opengl : glVertexAttribPointer, GL_FLOAT, GL_FALSE;

import liberty.core.logger.impl : Logger;
import liberty.core.math : Vector2F, Vector3F;
import liberty.core.model.impl : Model;
import liberty.core.model.raw : RawModel;
import liberty.core.objects.mesh : StaticMesh;
import liberty.graphics.array : GfxArray;
import liberty.graphics.buffer.constants : GfxBufferTarget, GfxDataUsage;
import liberty.graphics.buffer.impl : GfxBuffer;
import liberty.graphics.texture.cache : TextureCache;
import liberty.graphics.texture.impl : Texture;
import liberty.graphics.util : GfxUtil;
import liberty.graphics.vertex : Vertex;


/**
 * The resource manager class provides static functions that gives you the possibility
 * to create textures and models to manage them.
**/
final class ResourceManager {
  private {
    static TextureCache textureCache;
    static uint[] vaos;
    static uint[] vbos;
  }

  @disable this();

  /**
   * Initilaize resource manager.
  **/
  static void initialize() {
    textureCache = new TextureCache();
  }

  /**
   * Load a texture into memory using a relative resource path.
   * If texture is already loaded then just return it.
   * Returns: newly created texture.
  **/
  static Texture loadTexture(string resourcePath) {
    return textureCache.getTexture(resourcePath);
  }

  /**
   * Load a raw model into memory using vertex data.
   * Returns: newly created raw model.
  **/
  static RawModel loadRawModel(Vertex[] data) {
    // Create vertex array object for the model
    GfxArray vao = GfxUtil.createArray();
    vaos ~= vao.getHandle();

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxUtil.createBuffer(GfxBufferTarget.Array, GfxDataUsage.StaticDraw, data);    
    vbos ~= vbo.getHandle();

    version (__OPENGL__) {
      glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
      glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
      glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    }
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();

    return new RawModel(vao.getHandle(), data.length);
  }

  /**
   * Load a raw model into memory using vertex data and indices.
   * Indices are stored into the internal vertex buffer object static array.
   * Returns: newly created raw model.
  **/
  static RawModel loadRawModel(Vertex[] data, uint[] indices) {
    // Create vertex array object for the model
    GfxArray vao = GfxUtil.createArray();
    vaos ~= vao.getHandle();

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxUtil.createBuffer(GfxBufferTarget.Array, GfxDataUsage.StaticDraw, data);
    vbos ~= vbo.getHandle();

    // Create element buffer object for the model
    // This shouldn't be unbinded
    GfxBuffer ebo = GfxUtil.createBuffer(GfxBufferTarget.ElementArray, GfxDataUsage.StaticDraw, indices);
    vbos ~= ebo.getHandle();

    version (__OPENGL__) {
      glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
      glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
      glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    }
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();
    
    return new RawModel(vao.getHandle(), indices.length);
  }

  /**
   * Load a model into memory using a file with .obj extension.
   * Indices are stored into the internal vertex buffer object static array.
   * Currently it supports only format: 'v' 'vt' 'vn' and 'f a/a/a'.
   * Returns: newly created model.
  **/
  static Model loadModel(string path) {
    import std.array : split;
    import std.conv : to;
    import std.stdio : File;
    import std.string : strip;

    // Check extension	
    string[] splitArray = path.split(".");	
    immutable ext = splitArray[$ - 1];	
    if (ext != "obj") {	
      Logger.error(	
        "File format not supported for mesh data: " ~ ext,	
        typeof(this).stringof	
      );	
    }
    
    Vertex[] vertices;	

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
    scope (exit) file.close();

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
        auto tokens_1 = tokens[1].split("/");
        auto tokens_2 = tokens[2].split("/");
        auto tokens_3 = tokens[3].split("/");

        vertexIndices ~= tokens_1[0].to!uint - 1;
        vertexIndices ~= tokens_2[0].to!uint - 1;
        vertexIndices ~= tokens_3[0].to!uint - 1;

        uvIndices ~= tokens_1[1].to!uint - 1;
        uvIndices ~= tokens_2[1].to!uint - 1;
        uvIndices ~= tokens_3[1].to!uint - 1;

        normalIndices ~= tokens_1[2].to!uint - 1;
        normalIndices ~= tokens_2[2].to!uint - 1;
        normalIndices ~= tokens_3[2].to!uint - 1;
      }
    }

    foreach (i; 0..vertexIndices.length) {
      positions ~= tmpPositions[vertexIndices[i]];
      normals ~= tmpNormals[normalIndices[i]];
      uvs ~= tmpUvs[uvIndices[i]];

      vertices ~= Vertex(positions[i], normals[i], uvs[i]);
    }

    Model model = new Model();
    model.build(vertices, "res/textures/default.bmp");

    return model;	
  }

  /**
   * Release all vertex array objecs and vertex buffer objects and
   * index buffer object from the memory.
  **/
  static void releaseAllModels() {
    GfxArray.releaseVertexArrays(vaos);
    GfxBuffer.releaseBuffers(vbos);
  }
}