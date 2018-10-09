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

import derelict.opengl : glVertexAttribPointer, GL_FLOAT, GL_FALSE;

import liberty.core.logger.impl : Logger;
import liberty.core.model.raw : RawModel;
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
   * Load a model into memory using vertex data.
   * Returns: newly created model.
  **/
  static RawModel loadModel(Vertex[] data) {
    // Create vertex array object for the model
    GfxArray vao = GfxUtil.createArray();
    vaos ~= vao.getHandle();

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxUtil.createBuffer(GfxBufferTarget.Array, GfxDataUsage.StaticDraw, data);    
    vbos ~= vbo.getHandle();

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();

    return new RawModel(vao.getHandle(), data.length);
  }

  /**
   * Load a model into memory using vertex data and indices.
   * Indices are stored into the internal vertex buffer object static array.
   * Returns: newly created model.
  **/
  static RawModel loadModel(Vertex[] data, uint[] indices) {
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

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();
    
    return new RawModel(vao.getHandle(), indices.length);
  }

  import derelict.assimp3.assimp;
  import derelict.assimp3.types;

  /**
   * TODO
  **/
  static RawModel loadModel(string path) {
    import std.string : toStringz;

    const(aiScene)* scene = aiImportFile(path.toStringz, 0);
    if (scene is null)
      Logger.error("Couldn't load model: " ~ path, typeof(this).stringof);
    
    foreach (i; 0..scene.mRootNode.mNumMeshes) {
      const(aiMesh)* mesh = scene.mMeshes[scene.mRootNode.mMeshes[i]];
      //mesh ~= 
    }

    foreach (i; 0..scene.mRootNode.mNumChildren) {
      
    }
    return null;
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