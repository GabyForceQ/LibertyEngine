/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/resource.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *    - no opengl code here
**/
module liberty.resource;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.logger.impl;
import liberty.primitive.model;
import liberty.model;
import liberty.model.io;
import liberty.graphics.array;
import liberty.graphics.buffer.constants;
import liberty.graphics.buffer.impl;
import liberty.graphics.texture.cache;
import liberty.graphics.texture.impl;
import liberty.graphics.util;
import liberty.cubemap.vertex;
import liberty.surface.vertex;
import liberty.font.io;
import liberty.image.io;
import liberty.image.impl;

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
   * Returns newly created texture.
  **/
  static Texture loadTexture(string resourcePath) {
    return textureCache.getTexture(resourcePath);
  }

  /**
   *
  **/
  static Texture loadCubeMapTexture(string[6] resourcesPath) {
    return textureCache.getCubeMapTexture(resourcesPath);
  }

  /**
   * Load a raw model into memory using vertex data.
   * Returns newly created raw model.
  **/
  static RawModel loadRawModel(VERTEX)(VERTEX[] data) {
    // Create vertex array object for the model    
    GfxArray vao = GfxUtil.createArray();
    vaos ~= vao.getHandle();

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxUtil.createBuffer(GfxBufferTarget.Array, GfxDataUsage.StaticDraw, data);    
    vbos ~= vbo.getHandle();

    version (__OPENGL__) {
      static if (is(VERTEX == SurfaceVertex)) {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      } else static if (is(VERTEX == CubeMapVertex)) {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      } else {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.normal.offsetof);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      }
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
   * Returns newly created raw model.
  **/
  static RawModel loadRawModel(VERTEX)(VERTEX[] data, uint[] indices) {
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
      static if (is(VERTEX == SurfaceVertex)) {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      } else static if (is(VERTEX == CubeMapVertex)) {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      } else {
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.position.offsetof);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.normal.offsetof);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, VERTEX.sizeof, cast(void*)VERTEX.texCoord.offsetof);
      }
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
   * Returns newly created model.
  **/
  static PrimitiveModel loadModel(string path) {
    import std.array : split;

    // Check extension
    string[] splitArray = path.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "obj":
        return ModelIO.loadOBJFile(path);
      default:
        Logger.error(	
          "File format not supported for mesh data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
  }

  /**
   *
  **/
  static Image loadImage(string path) {
    import std.array : split;

    // Check extension
    string[] splitArray = path.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "bmp", "BMP":
        return ImageIO.loadBMPFile(path);
      case "png", "PNG":
        return ImageIO.loadPNGFile(path);
      default:
        Logger.error(	
          "File format not supported for image data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
  }

  /**
   *
  **/
  static void loadFont(string path) {
    import std.array : split;

    // Check extension
    string[] splitArray = path.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "fnt":
        return FontIO.loadFNTFile(path);
      default:
        Logger.error(	
          "File format not supported for font data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
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