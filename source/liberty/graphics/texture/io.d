/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.io;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.engine;
import liberty.graphics.texture.cache;
import liberty.graphics.texture.constants;
import liberty.graphics.texture.impl;
import liberty.image.format.bmp;
import liberty.image.io;

/**
 *
**/
final abstract class TextureIO {
  private {
    static TextureCache textureCache;
  }

  /**
   * Load a texture into memory using a relative resource path.
   * If texture is already loaded then just return it.
   * Returns newly created texture.
  **/
  static Texture loadTexture(string resourcePath) {
    if (textureCache is null)
      textureCache = new TextureCache();

    return textureCache.getTexture(resourcePath);
  }

  /**
   *
  **/
  static Texture loadCubeMapTexture(string[6] resourcesPath) {
    if (textureCache is null)
      textureCache = new TextureCache();

    return textureCache.getCubeMapTexture(resourcesPath);
  }

  package static Texture loadBMP(string resourcePath) {
    Texture texture = new Texture();

    // Load texture form file
    auto image = cast(BMPImage)ImageIO.loadImage(resourcePath);

    // Generate and bind texture
    texture.generateTextures();
    texture.bind(TextureType.TEX_2D);

    version (__OPENGL__) {
      glTexImage2D(
        GL_TEXTURE_2D, 
        0, 
        GL_RGBA,
        image.getWidth(),
        image.getHeight(),
        0,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        cast(ubyte*)image.getPixelData()
      );

      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

      // Set anisotropic filtering
      const anisotropicAmount = GfxEngine.getBackend.getOptions.anisotropicFiltering;
      if (anisotropicAmount)
        glTexParameterf(GL_TEXTURE_2D, 0x84FE, anisotropicAmount);

    }

    texture
      .setLODBias(0.2f)
      .generateMipmap()
      .unbind();

    // Set Texture width and height
    texture.setExtent(image.getWidth(), image.getHeight());

    return texture;
  }

  // this shouldn't be public
  static Texture loadBMP(BMPImage image) {
    Texture texture = new Texture();

    // Generate OpenGL texture
    texture.generateTextures();

    version (__OPENGL__) {
      texture.bind(TextureType.TEX_2D);

      glTexImage2D(
        GL_TEXTURE_2D, 
        0, 
        GL_RGBA,
        image.getWidth(),
        image.getHeight(),
        0,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        cast(ubyte*)image.getPixelData()
      );

      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
      
      texture
        .setLODBias(-0.4f)
        .generateMipmap()
        .unbind();
    }

    // Set Texture width and height
    texture.setExtent(image.getWidth(), image.getHeight());

    return texture;
  }
}