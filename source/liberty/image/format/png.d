/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/image/format/png.d)
 * Documentation:
 * Coverage:
**/
module liberty.image.format.png;

import liberty.image.impl;

/**
 *
**/
struct PNGChunk {
  /**
   *
  **/
  uint size;

  /**
   *
  **/
  ubyte[4] type;

  /**
   *
  **/
  ubyte[] data;

  /**
   *
  **/
  ubyte[] crc32;

  /**
   *
  **/
  void clear() {
    if (data.ptr !is null)
      data.destroy();

    if (crc32.ptr !is null)
      crc32.destroy();
  }
}

/**
 *
**/
struct PNGHeader {
  union {
    struct {
      /**
       *
      **/
      uint width;

      /**
       *
      **/
      uint height;

      /**
       *
      **/
      uint bitDepth;

      /**
       *
      **/
      uint colorType;

      /**
       *
      **/
      ubyte compressionMethod;

      /**
       *
      **/
      ubyte filterMethod;

      /**
       *
      **/
      ubyte interlaceMethod;
    }

    /**
     *
    **/
    ubyte[13] bytes;
  }
}

/**
 *
**/
final class PNGImage : Image {
  private {
    PNGHeader header;
  }

  /**
   *
  **/
  this() {}
}