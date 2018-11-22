/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.io;

import bindbc.opengl;

import std.stdio : File;
import std.string : strip;
import std.array : split;

import liberty.image.format.bmp;
import liberty.graphics.texture.constants;
import liberty.graphics.texture.impl;
import liberty.resource;

/**
 *
**/
final abstract class CubeMapIO {
  /**
   *
  **/
  static Texture loadCubeMap(string[6] resourcesPath) {
    Texture texture = new Texture();
    BMPImage[6] images;

    version (__OPENGL__) {
      // Generate OpenGL texture
      texture.generateTextures();
      texture.bind(TextureType.CUBE_MAP);
    }

    static foreach (i; 0..6) {
      // Load texture form file
      images[i] = cast(BMPImage)ResourceManager.loadImage(resourcesPath[i]);

      version (__OPENGL__) {
        glTexImage2D(
          GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 
          0, 
          GL_RGBA,
          images[i].getWidth(),
          images[i].getHeight(),
          0,
          GL_BGRA,
          GL_UNSIGNED_BYTE,
          cast(ubyte*)images[i].getPixelData()
        );
      }
    }

    version (__OPENGL__) {
      //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
      
      texture
        .setLODBias(-0.4f)
        .generateMipmap()
        .unbind();
    }

    // Set Texture width and height
    texture.setExtent(images[0].getWidth(), images[0].getHeight());

    return texture;
  }
}