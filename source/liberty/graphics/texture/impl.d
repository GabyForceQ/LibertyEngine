/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.impl;

import bindbc.opengl;
import liberty.logger.impl;
import liberty.graphics.texture.constants;

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
    TextureType type;
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
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) generateTextures() {
    glGenTextures(1, &id);
    return this;
  }

  /**
   * Delete texture internally.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) deleteTextures() {
    glDeleteTextures(1, &id);
    return this;
  }

  /**
   * Bind the texture.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) bind(TextureType type) {
    final switch (type) with (TextureType) {
      case NONE:
        Logger.error("Cannot bind NONE to texture.", typeof(this).stringof);
        break;
      case TEX_2D:
        glBindTexture(GL_TEXTURE_2D, id);
        break;
      case CUBE_MAP:
        glBindTexture(GL_TEXTURE_CUBE_MAP, id);
        break;
    }

    this.type = type;
    isBind = true;

    return this;
  }

  /**
   * Unbind the texture.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) unbind() {
    final switch (type) with (TextureType) {
      case NONE:
        Logger.error("Cannot unbind NONE from texture.", typeof(this).stringof);
        break;
      case TEX_2D:
        glBindTexture(GL_TEXTURE_2D, 0);
        break;
      case CUBE_MAP:
        glBindTexture(GL_TEXTURE_CUBE_MAP, 0);
        break;
    }

    isBind = false;
    return this;
  }

  /**
   * Returns texture unique id.
  **/
  uint getId()   const {
    return id;
  }

  /**
   * Returns the relative texure path.
  **/
  string getRelativePath()   const {
    return path;
  }

  /**
   * Set both width and height of texture.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setExtent(uint width, uint height)   {
    this.width = width;
    this.height = height;
    return this;
  }

  /**
   * Set the texture width.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setWidth(uint width)   {
    this.width = width;
    return this;
  }

  /**
   * Returns texture width.
  **/
  uint getWidth()   const {
    return width;
  }

  /**
   * Set the texture height.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setHeight(uint height)   {
    this.height = height;
    return this;
  }

  /**
   * Returns texture height.
  **/
  uint getHeight()   const {
    return height;
  }

  /**
   * Generate mipmap for texture 2D.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) generateMipmap() {
    glGenerateMipmap(GL_TEXTURE_2D);      
    return this;
  }

  /**
   * Set texture level of detail bias.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setLODBias(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=" || op == "%=") {
    mixin("lodBias " ~ op ~ " value;");
    const bindUnbind = !isBind; 
    if (bindUnbind)
      bind(type);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_LOD_BIAS, lodBias);
    if (bindUnbind)
      unbind;
    return this;
  }

  /**
   * Returns the texture level of detail bias.
  **/
  float getLODBias()   const {
    return lodBias;
  }

  /**
   * Returns the type of the texture.
   * For available options see $(D TextureType).
  **/
  TextureType getType()   const {
    return type;
  }

  package void setRealtivePath(string path)   {
    this.path = path;
  }
}