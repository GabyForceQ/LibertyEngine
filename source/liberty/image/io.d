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

import liberty.logger.impl;
import liberty.image.format;
import liberty.image.impl;
import liberty.io.manager;
import liberty.graphics.texture.impl;

/**
 * Singleton class used for loading image files.
 * It's a manager class so it implements $(D ManagerBody).
**/
final abstract class ImageIO {
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
        return loadBMPFile(path);
      case "png", "PNG":
        return loadPNGFile(path);
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
  static BMPImage createImage(BMPHeader header, ubyte[] pixelData) {
    return new BMPImage(header, pixelData);
  }

  private static BMPImage loadBMPFile(string resourcePath) {
    char[] buf;

    // Read bmp file and put its content into a buffer
    if (!IOManager.readFileToBuffer(resourcePath, buf, "rb"))
      Logger.error("Cannot read " ~ resourcePath ~ " file.", typeof(this).stringof);

    // Check if it is really a bmp image
    if (!isBMPFormat(buf[0x00..0x02]))
      Logger.error("Not *.bmp file.", typeof(this).stringof);

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
    return createImage(header, pixelData);
  }

  private static PNGImage loadPNGFile(string resourcePath) {
    char[] buf;

    // Read png file and put its content into a buffer
    if (!IOManager.readFileToBuffer(resourcePath, buf, "rb")) {
      assert(0, "Operation failed!");
    }

    // Check if it is really a png image
    if (!isPNGFormat(buf[0x00..0x08])) {
      assert(0, "Not PNG image!");
    }

    Logger.todo("static PNGImage loadPNGFile(string resourcePath) {..}", typeof(this).stringof);
    Logger.error("Previous TODO", typeof(this).stringof);

    return null;
  }

  private static bool isBMPFormat(in char[2] bytes)  {
    return bytes[0] == 'B' && bytes[1] == 'M';
  }

  private static bool isPNGFormat(in char[8] bytes)  {
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