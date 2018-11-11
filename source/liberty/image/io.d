/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/image/io.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *    - move in resource manager
**/
module liberty.image.io;

//
version (__OPENGL__)
  import bindbc.opengl;

import liberty.image.format;
import liberty.image.impl;
import liberty.io.manager;
import liberty.graphics.texture.impl;
import liberty.resource;

/**
 * Singleton class used for loading image files.
 * It's a manager class so it implements $(D ManagerBody).
**/
final class ImageIO {
  /**
   *
  **/
  static BMPImage loadBMPFile(string resourcePath) {
    char[] buf;

    // Read bmp file and put its content into a buffer
    if (!IOManager.readFileToBuffer(resourcePath, buf, "rb")) {
      assert (0, "Operation failed!");
    }

    // Check if it is really a bmp image
    if (!isBMPFormat(buf[0x00..0x02])) {
      assert (0, "Not BMP image!");
    }

    BMPHeader header;
    ubyte[] pixelData;

    // Fill bmp header
    header.dataPosition = *cast(uint*)&buf[0x0A];
    header.size = *cast(uint*)&buf[0x22];
    header.width = *cast(uint*)&buf[0x12];
    header.height = *cast(uint*)&buf[0x16];

    if (header.size == 0)
      header.size = header.width * header.height * 4;
    
    if (header.dataPosition == 0)
      header.dataPosition = IMPLICIT_BMP_HEADER_DATA_POSITION;

    // Fill bmp pixel data
    pixelData = cast(ubyte[])buf[header.dataPosition..buf.length];

    // Create the image in memory and return it
    return new BMPImage(header, pixelData);
  }

  /**
   *
  **/
  static PNGImage loadPNGFile(string resourcePath) {
    /*char[] buf;

    // Read png file and put its content into a buffer
    if (!IOManager.readFileToBuffer(resourcePath, buf, "rb")) {
      assert (0, "Operation failed!");
    }

    // Check if it is really a png image
    if (!isPNGFormat(buf[0x00..0x08])) {
      assert (0, "Not PNG image!");
    }*/

    import liberty.logger : Logger;
    Logger.todo("static PNGImage loadPNGFile(string resourcePath) {..}", typeof(this).stringof);
    Logger.error("Previous TODO", typeof(this).stringof);

    return null;
  }

  /**
   *
  **/
  static Texture loadBMPAsTexture(string resourcePath) {
    // Check if service is running
    Texture texture = new Texture();

    // Load texture form file
    auto image = cast(BMPImage)ResourceManager.loadImage(resourcePath);

    // Generate OpenGL texture
    texture.generateTextures();

    version (__OPENGL__) {
      texture.bind();

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
        .setLODBias(0.0f)
        .generateMipmap()
        .unbind();
    }

    // Set Texture width and height
    texture.setExtent(image.getWidth(), image.getHeight());

    return texture;
  }

  private static bool isBMPFormat(in char[2] bytes) nothrow {
    return bytes[0] == 'B' && bytes[1] == 'M';
  }

  private static bool isPNGFormat(in char[8] bytes) nothrow {
    return
      cast(ubyte)bytes[0] == 137 &&
      cast(ubyte)bytes[1] == 80 &&
      cast(ubyte)bytes[2] == 78 &&
      cast(ubyte)bytes[3] == 71 &&
      cast(ubyte)bytes[4] == 13 &&
      cast(ubyte)bytes[5] == 10 &&
      cast(ubyte)bytes[6] == 26 &&
      cast(ubyte)bytes[7] == 10;
  }
}