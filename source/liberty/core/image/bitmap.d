/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/image/bitmap.d, _bitmap.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.image.bitmap;

import std.string;
import derelict.freeimage.freeimage;
import liberty.core.logger : Logger;

/**
 * Image bitmap wrapper.
**/
final class Bitmap {
  private {
    FIBITMAP* _bitmap;
  }

  /**
   * Load an image from file.
  **/
  this(string filename, int flags = 0) {
    _bitmap = null;
    const(char)* filenameZ = toStringz(filename);
    FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;
    fif = FreeImage_GetFileType(filenameZ, 0);
    if (fif == FIF_UNKNOWN) {
      fif = FreeImage_GetFIFFromFilename(filenameZ);
    }
    if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif)) {
      _bitmap = FreeImage_Load(fif, filenameZ, flags);
    }
    if (_bitmap is null) {
      Logger.error(
        "Couldn't load image: " ~ filename,
        typeof(this).stringof
      );
    }
  }

  /**
   * Loads from existing bitmap handle.
  **/
  this(FIBITMAP* bitmap) {
    if (bitmap is null) {
      Logger.error(
        "Cannot make FIBitmap from null handle",
        typeof(this).stringof
      );
    }
    _bitmap = bitmap;
  }

  /**
   * Creates an image from from existing memory data.
  **/
  this(
    ubyte* data, 
    int width, 
    int height, 
    int pitch, 
    uint bpp, 
    uint redMask, 
    uint blueMask, 
    uint greenMask, 
    bool topDown = false
  ) {
    _bitmap = FreeImage_ConvertFromRawBits(
      data, 
      width, 
      height, 
      pitch, 
      bpp, 
      redMask, 
      greenMask, 
      blueMask, 
      FALSE
    );
    if (_bitmap is null) {
      Logger.error(
        "Cannot make FIBitmap from raw data",
        typeof(this).stringof
      );
    }
  }

  /**
   * Releases the Image bitmap resource.
  **/
  ~this() {
    if (_bitmap !is null) {
      FreeImage_Unload(_bitmap);
      _bitmap = null;
    }
  }

  /**
   * Saves an image to a file.
  **/
  void save(string filename, int flags = 0) {
    const(char)* filenameZ = toStringz(filename);
    FREE_IMAGE_FORMAT fif = FreeImage_GetFIFFromFilename(filenameZ);
    if (fif == FIF_UNKNOWN) {
      Logger.error(
        "Couldn't guess format for filename: " ~ filename,
        typeof(this).stringof
      );
    }
    FreeImage_Save(fif, _bitmap, filenameZ, flags);
  }

  /**
   * Returns image width.
  **/
  uint getWidth() {
    return FreeImage_GetWidth(_bitmap);
  }

  /**
   * Returns image height.
  **/
  uint getHeight() {
    return FreeImage_GetHeight(_bitmap);
  }

  /**
   * Returns image type.
  **/
  FREE_IMAGE_TYPE getImageType() {
    return FreeImage_GetImageType(_bitmap);
  }

  /**
   * Returns number of dots per meter x.
  **/
  uint getDotCountPerMeterX() {
    return FreeImage_GetDotsPerMeterX(_bitmap);
  }

  /**
   * Returns number of dots per meter y.
  **/
  uint getDotCountPerMeterY() {
    return FreeImage_GetDotsPerMeterY(_bitmap);
  }

  /**
   * Returns color type.
  **/
  FREE_IMAGE_COLOR_TYPE getColorType() {
    return FreeImage_GetColorType(_bitmap);
  }

  /**
   * Returns red channel bit mask.
  **/
  uint getRedMask() {
    return FreeImage_GetRedMask(_bitmap);
  }

  /**
   * Returns green channel bit mask.
  **/
  uint getGreenMask() {
    return FreeImage_GetGreenMask(_bitmap);
  }

  /**
   * Returns blue channel bit mask.
  **/
  uint getBlueMask() {
    return FreeImage_GetBlueMask(_bitmap);
  }

  /**
   * Returns bits per pixels.
  **/
  uint getBitsPerPixel() {
    return FreeImage_GetBPP(_bitmap);
  }

  /**
   * Returns a pointer to pixels data.
  **/
  void* getData() {
    return FreeImage_GetBits(_bitmap);
  }

  /**
   * Returns pitch between scanlines in bytes.
  **/
  uint getPitch() {
    return FreeImage_GetPitch(_bitmap);
  }

  /**
   * Returns a pointer to scanline y.
  **/
  void* getScanLine(int y) {
    return FreeImage_GetScanLine(_bitmap, y);
  }

  /**
   * Convert an image to 4-bits.
   * Returns converted image.
  **/
  Bitmap convertTo4Bits() {
    return new Bitmap(FreeImage_ConvertTo4Bits(_bitmap));
  }

  /**
   * Convert an image to 8-bits.
   * Returns converted image.
  **/
  Bitmap convertTo8Bits() {
    return new Bitmap(FreeImage_ConvertTo8Bits(_bitmap));
  }

  /**
   * Convert an image to greyscale.
   * Returns converted image.
  **/
  Bitmap convertToGreyscale() {
    return new Bitmap(FreeImage_ConvertToGreyscale(_bitmap));
  }

  /**
   * Convert an image to 16-bits 555.
   * Returns converted image.
  **/
  Bitmap convertTo16Bits555() {
    return new Bitmap(FreeImage_ConvertTo16Bits555(_bitmap));
  }

  /**
   * Convert an image to 16-bits 565.
   * Returns converted image.
  **/
  Bitmap convertTo16Bits565() {
    return new Bitmap(FreeImage_ConvertTo16Bits565(_bitmap));
  }

  /**
   * Convert an image to 24-bits.
   * Returns converted image.
  **/
  Bitmap convertTo24Bits() {
    return new Bitmap(FreeImage_ConvertTo24Bits(_bitmap));
  }

  /**
   * Convert an image to 32-bits.
   * Returns converted image.
  **/
  Bitmap convertTo32Bits() {
    return new Bitmap(FreeImage_ConvertTo32Bits(_bitmap));
  }

  /**
   * Convert an image to another format.
   * Returns converted image.
  **/
  Bitmap convertToType(FREE_IMAGE_TYPE dstType, bool scaleLinear = true) {
    FIBITMAP* converted = FreeImage_ConvertToType(_bitmap, dstType, scaleLinear);
    if (converted is null) {
      Logger.warning(
        "Disallowed conversion",
        typeof(this).stringof
      );
    }
    return new Bitmap(converted);
  }

  /**
   * Convert an image to float format.
   * Returns converted image.
  **/
  Bitmap convertToFloat() {
    return new Bitmap(FreeImage_ConvertToFloat(_bitmap));
  }

  /**
   * Convert an image to RGBF format.
   * Returns converted image.
  **/
  Bitmap convertToRGBF() {
    return new Bitmap(FreeImage_ConvertToRGBF(_bitmap));
  }

  /**
   * Convert an image to UINT16 format.
   * Returns converted image.
  **/
  Bitmap convertToUINT16() {
    return new Bitmap(FreeImage_ConvertToUINT16(_bitmap));
  }

  /**
   * Convert an image to RGB16 format.
   * Returns converted image.
  **/
  Bitmap convertToRGB16() {
    return new Bitmap(FreeImage_ConvertToRGB16(_bitmap));
  }

  /**
   * Clone an image.
   * Returns cloned image.
  **/
  Bitmap clone() {
    return new Bitmap(FreeImage_Clone(_bitmap));
  }

  /**
   * Apply color quantization.
  **/
  Bitmap colorQuantize(FREE_IMAGE_QUANTIZE quantize) {
    return new Bitmap(FreeImage_ColorQuantize(_bitmap, quantize));
  }

  /**
   * Apply tone-mapping operator.
  **/
  Bitmap toneMapDrago03(double gamma = 2.2, double exposure = 0.0) {
    return new Bitmap(FreeImage_TmoDrago03(_bitmap, gamma, exposure));
  }

  /**
   * Rescale the image.
  **/
  Bitmap rescale(int newWidth, int newHeight, FREE_IMAGE_FILTER filter) {
    return new Bitmap(FreeImage_Rescale(_bitmap, newWidth, newHeight, filter));
  }

  /**
   * Flips the image horizontally.
  **/
  void horizontalFlip() {
    if (FreeImage_FlipHorizontal(_bitmap) == FALSE) {
      Logger.warning(
        "Cannot flip image horizontally",
        typeof(this).stringof
      );
    }
  }

  /**
   * Flip the image vertically.
  **/
  void verticalFlip() {
    if (FreeImage_FlipVertical(_bitmap) == FALSE) {
      Logger.warning(
        "Cannot flip image vertically",
        typeof(this).stringof
      );
    }
  }

  /**
   * Rotate the image.
   * Returns rotated image.
  **/
  Bitmap rotate(double angle, void* bkColor = null) {
    return new Bitmap(FreeImage_Rotate(_bitmap, angle, bkColor));
  }

  /**
   * Returns image number of channels.
  **/
  uint getChannelsCount() {
    immutable uint bytespp = FreeImage_GetLine(_bitmap) / FreeImage_GetWidth(_bitmap);
    immutable uint samples = bytespp / getImageType().sizeof;
    return samples;
  }
}