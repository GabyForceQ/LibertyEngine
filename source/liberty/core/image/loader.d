/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/image/loader.d, _loader.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *    - move in resource manager
**/
module liberty.core.image.loader;

//
version (__OPENGL__)
  import derelict.opengl;

import liberty.core.logger.impl : Logger;
import liberty.core.image.bitmap : Bitmap;
import liberty.graphics.texture.impl : Texture;

/**
 * Singleton class used for loading image files.
 * It's a manager class so it implements $(D ManagerBody).
**/
final class ImageLoader {

  /**
   *
  **/
  static Texture loadBMP(string resourcePath) {
    // Check if service is running
    Texture texture;

    // Load texture form file
    auto bitmap = new Bitmap(resourcePath);

    // Generate OpenGL texture
    texture.generateTextures();

    version (__OPENGL__) {
      // Bind the texture
      glBindTexture(GL_TEXTURE_2D, texture.getId());
      glTexImage2D(
        GL_TEXTURE_2D, 
        0, 
        GL_RGBA8, //GL_RGBA,
        bitmap.getWidth(),
        bitmap.getHeight(),
        0,
        GL_RGBA,
        GL_UNSIGNED_INT_8_8_8_8, //GL_UNSIGNED_BYTE,
        bitmap.getData()
      );

      // Set texture parameters
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

      // Generate mipmap
      glGenerateMipmap(GL_TEXTURE_2D);

      // Unbind the current texture
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    // Set Texture width and height
    texture.width = bitmap.getWidth();
    texture.height = bitmap.getHeight();

    return texture;
  }
}