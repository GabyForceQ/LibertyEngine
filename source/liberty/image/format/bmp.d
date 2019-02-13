/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/image/format/png.d)
 * Documentation:
 * Coverage:
**/
module liberty.image.format.bmp;

import liberty.image.impl;
import liberty.math.vector;

/**
 *
**/
enum IMPLICIT_BMP_HEADER_DATA_POSITION = 54;

/**
 *
**/
struct BMPHeader {
  /**
   *
  **/
  uint dataPosition;

  /**
   *
  **/
  uint size;

  /**
   *
  **/
  uint width;

  /**
   *
  **/
  uint height;
}

/**
 *
**/
final class BMPImage : Image {
  private {
    BMPHeader header;
    ubyte[] data;
  }

  /**
   *
  **/
  this(BMPHeader header, ubyte[] pixelData) {
    this.header = header;
    this.pixelData = pixelData;
  }

  /**
   *
  **/
  uint getSize()   const {
    return header.size;
  }

  /**
   * Retursn image width in pixels.
  **/
  uint getWidth()   const {
    return header.width;
  }

  /**
   * Retursn image height in pixels.
  **/
  uint getHeight()   const {
    return header.height;
  }

  /**
   *
  **/
  float getRGBPixelColor(int x, int y)   {
    const ubyte b = pixelData[header.width * y * 4 + x * 4 + 0];
    const ubyte g = pixelData[header.width * y * 4 + x * 4 + 1];
    const ubyte r = pixelData[header.width * y * 4 + x * 4 + 2];

    return -((r << 16) | (g << 8) | (b << 0));
  }

  /**
   *
  **/
  Color4 getRGBAPixel(int x, int y)   {
    const ubyte b = pixelData[header.width * y * 4 + x * 4 + 0];
    const ubyte g = pixelData[header.width * y * 4 + x * 4 + 1];
    const ubyte r = pixelData[header.width * y * 4 + x * 4 + 2];
    const ubyte a = pixelData[header.width * y * 4 + x * 4 + 3];
    return Color4(r, g, b, a);
  }

  /**
   *
  **/
  ubyte[] getData()   {
    return data;
  }
}