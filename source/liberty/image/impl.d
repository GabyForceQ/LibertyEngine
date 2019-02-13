/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/image/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.image.impl;

/**
 * Base class for all image format classes.
**/
abstract class Image {
  protected {
    uint channelCount;
    uint bitDepth;
    uint bytesPerChannel;
    ubyte[] pixelData;
  }

  /**
   * Returns the number of channels that image has.
   * For example, if image has 4 channels it returns 3.
  **/
  uint getChannelCount()   const {
    return channelCount;
  }

  /**
   *
  **/
  uint getBithDepth()   const {
    return bitDepth;
  }

  /**
   *
  **/
  uint getBitsPerChannel()   const {
    return bytesPerChannel;
  }

  /**
   *
  **/
  ubyte[] getPixelData()   {
    return pixelData;
  }
}