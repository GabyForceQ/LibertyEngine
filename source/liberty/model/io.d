/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.io;

import liberty.model.raw;
import liberty.graphics.buffer;

/**
 *
**/
final abstract class ModelIO {
  /**
   * Load a raw model into memory using vertex data.
   * Returns newly created raw model.
  **/
  static RawModel loadRawModel(VERTEX)(VERTEX[] data) {
    // Create vertex array object for the model    
    GfxVertexArray vao = GfxVertexArray.createArray();
    vao.appendToVAOs(vao.getHandle());

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxBuffer.createBuffer(GfxBufferTarget.ARRAY, GfxDataUsage.STATIC_DRAW, data);    
    vbo.appendToVBOs(vbo.getHandle());

    // Bind vertex attribute pointer
    VERTEX.bindAttributePointer();
    
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
    GfxVertexArray vao = GfxVertexArray.createArray();
    vao.appendToVAOs(vao.getHandle());

    // Create vertex buffer object for the model
    GfxBuffer vbo = GfxBuffer.createBuffer(GfxBufferTarget.ARRAY, GfxDataUsage.STATIC_DRAW, data);
    vbo.appendToVBOs(vbo.getHandle());

    // Create element buffer object for the model
    // This shouldn't be unbinded
    GfxBuffer ebo = GfxBuffer.createBuffer(GfxBufferTarget.ELEMENT_ARRAY, GfxDataUsage.STATIC_DRAW, indices);
    ebo.appendToVBOs(ebo.getHandle());

    // Bind vertex attribute pointer
    VERTEX.bindAttributePointer();
    
    // Unbind vertex buffer object
    vbo.unbind();

    // Unbind vertex array object
    vao.unbind();
    
    return new RawModel(vao.getHandle(), indices.length);
  }
}