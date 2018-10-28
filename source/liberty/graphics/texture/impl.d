/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.impl;

version (__OPENGL__)
  import bindbc.opengl;

/**
 *
**/
final class Texture {
  private {
    uint id;
    string path;
    uint width;
    uint height;
    bool isBind = false;
    float lodBias = float.nan;
  }

  /**
   * Craete an empty texture.
  **/
  this() {}

  /**
   * Create a texture with a given id.
  **/
  this(uint id) {
    this.id = id;
  }

  /**
   * Generate texture internally.
   * Returns reference to this.
  **/
  Texture generateTextures() {
    version (__OPENGL__)
      glGenTextures(1, &id);

    return this;
  }

  /**
   * Delete texture internally.
   * Returns reference to this.
  **/
  Texture deleteTextures() {
    version (__OPENGL__)
      glDeleteTextures(1, &id);

    return this;
  }

  /**
   * Bind the texture.
   * Returns reference to this.
  **/
  Texture bind() {
    version (__OPENGL__)
      glBindTexture(GL_TEXTURE_2D, id);

    isBind = true;
    return this;
  }

  /**
   * Unbind the texture.
   * Returns reference to this.
  **/
  Texture unbind() {
    version (__OPENGL__)
      glBindTexture(GL_TEXTURE_2D, 0);

    isBind = false;
    return this;
  }

  /**
   * Returns texture unique id.
  **/
  uint getId() pure nothrow const {
    return id;
  }

  /**
   * Returns the relative texure path.
  **/
  string getRelativePath() pure nothrow const {
    return path;
  }

  /**
   * Set both width and height of texture.
   * Returns reference to this.
  **/
  Texture setExtent(uint width, uint height) pure nothrow {
    this.width = width;
    this.height = height;
    return this;
  }

  /**
   * Set the texture width.
   * Returns reference to this.
  **/
  Texture setWidth(uint width) pure nothrow {
    this.width = width;
    return this;
  }

  /**
   * Returns texture width.
  **/
  uint getWidth() pure nothrow const {
    return width;
  }

  /**
   * Set the texture height.
   * Returns reference to this.
  **/
  Texture setHeight(uint height) pure nothrow {
    this.height = height;
    return this;
  }

  /**
   * Returns texture height.
  **/
  uint getHeight() pure nothrow const {
    return height;
  }

  /**
   * Generate mipmap for texture 2D.
   * Returns reference to this.
  **/
  Texture generateMipmap() {
    version (__OPENGL__)
      glGenerateMipmap(GL_TEXTURE_2D);
      
    return this;
  }

  /**
   * Set texture level of detail bias.
   * Returns reference to this.
  **/
  Texture setLODBias(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=" || op == "%=") {
    mixin ("lodBias " ~ op ~ " value;");
    const bindUnbind = !isBind; 

    if (bindUnbind)
      bind();

    version (__OPENGL__)
      glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_LOD_BIAS, lodBias);

    if (bindUnbind)
      unbind();

    return this;
  }

  /**
   * Returns the texture level of detail bias.
  **/
  float getLODBias() pure nothrow const {
    return lodBias;
  }
}