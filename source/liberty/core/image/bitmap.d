/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/imaging/bitmap.d, _bitmap.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.image.bitmap;
import std.string;
import derelict.freeimage.freeimage;
import liberty.core.image.manager;
/// Image bitmap wrapper.
final class Bitmap {
    private {
        FIBITMAP* _bitmap;
    }
    /// Load an image from file.
    /// Throws $(D ImageException) on error.
    this(string filename, int flags = 0) {
        _bitmap = null;
        const(char)* filenameZ = toStringz(filename);
        FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;
        fif = FreeImage_GetFileType(filenameZ, 0);
        if(fif == FIF_UNKNOWN) {
            fif = FreeImage_GetFIFFromFilename(filenameZ);
        }
        if((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif)) {
            _bitmap = FreeImage_Load(fif, filenameZ, flags);
        }
        if (_bitmap is null)
            throw new ImageException(format("Coudln't load image %s", filename));
    }
    /// Loads from existing bitmap handle.
    /// Throws $(D ImageException) on error.
    this(FIBITMAP* bitmap) {
        if (bitmap is null)
            throw new ImageException("Cannot make FIBitmap from null handle");
        _bitmap = bitmap;
    }
    /// Creates an image from from existing memory data.
    /// Throws $(D ImageException) on error.
    this(ubyte* data, int width, int height, int pitch, uint bpp, uint redMask, uint blueMask, uint greenMask, bool topDown = false) {
        _bitmap = FreeImage_ConvertFromRawBits(data, width, height, pitch, bpp, redMask, greenMask, blueMask, FALSE);
        if (_bitmap is null)
            throw new ImageException("Cannot make FIBitmap from raw data");
    }
    /// Releases the Image bitmap resource.
    ~this() {
        if (_bitmap !is null) {
            //debug import liberty.core.memory : ensureNotInGC;
            //debug ensureNotInGC("FIBitmap");
            FreeImage_Unload(_bitmap);
            _bitmap = null;
        }
    }
    /// Saves an image to a file.
    /// Throws $(D ImageException) on error.
    void save(string filename, int flags = 0) {
        const(char)* filenameZ = toStringz(filename);
        FREE_IMAGE_FORMAT fif = FreeImage_GetFIFFromFilename(filenameZ);
        if (fif == FIF_UNKNOWN)
            throw new ImageException(format("Coudln't guess format for filename %s", filename));
        FreeImage_Save(fif, _bitmap, filenameZ, flags);
    }
    /// Get Width of the image.
    uint width() {
        return FreeImage_GetWidth(_bitmap);
    }
    /// Get Height of the image.
    uint height() {
        return FreeImage_GetHeight(_bitmap);
    }
    ///
    FREE_IMAGE_TYPE imageType() {
        return FreeImage_GetImageType(_bitmap);
    }
    ///
    uint dotsPerMeterX() {
        return FreeImage_GetDotsPerMeterX(_bitmap);
    }
    ///
    uint dotsPerMeterY() {
        return FreeImage_GetDotsPerMeterY(_bitmap);
    }
    ///
    FREE_IMAGE_COLOR_TYPE colorType() {
        return FreeImage_GetColorType(_bitmap);
    }
    /// Get Red channel bit mask.
    uint redMask() {
        return FreeImage_GetRedMask(_bitmap);
    }
    /// Get Green channel bit mask.
    uint greenMask() {
        return FreeImage_GetGreenMask(_bitmap);
    }
    /// Get Blue channel bit mask.
    uint blueMask() {
        return FreeImage_GetBlueMask(_bitmap);
    }
    /// Get Bits per pixels.
    uint BPP() {
        return FreeImage_GetBPP(_bitmap);
    }
    /// Get A pointer to pixels data.
    void* data() {
        return FreeImage_GetBits(_bitmap);
    }
    /// Get Pitch between scanlines in bytes.
    uint pitch() {
        return FreeImage_GetPitch(_bitmap);
    }
    /// Get A pointer to scanline y.
    void* scanLine(int y) {
        return FreeImage_GetScanLine(_bitmap, y);
    }
    /// Converts an image to 4-bits.
    /// Get Converted image.
    Bitmap convertTo4Bits() {
        return new Bitmap(FreeImage_ConvertTo4Bits(_bitmap));
    }
    /// Converts an image to 8-bits.
    /// Get Converted image.
    Bitmap convertTo8Bits() {
        return new Bitmap(FreeImage_ConvertTo8Bits(_bitmap));
    }
    /// Converts an image to greyscale.
    /// Get Converted image.
    Bitmap convertToGreyscale() {
        return new Bitmap(FreeImage_ConvertToGreyscale(_bitmap));
    }
    /// Converts an image to 16-bits 555.
    /// Get Converted image.
    Bitmap convertTo16Bits555() {
        return new Bitmap(FreeImage_ConvertTo16Bits555(_bitmap));
    }
    /// Converts an image to 16-bits 565.
    /// Get Converted image.
    Bitmap convertTo16Bits565() {
        return new Bitmap(FreeImage_ConvertTo16Bits565(_bitmap));
    }
    /// Converts an image to 24-bits.
    /// Get Converted image.
    Bitmap convertTo24Bits() {
        return new Bitmap(FreeImage_ConvertTo24Bits(_bitmap));
    }
    /// Converts an image to 32-bits.
    /// Throws $(D ImageException) on error.
    /// Get Converted image.
    Bitmap convertTo32Bits() {
        return new Bitmap(FreeImage_ConvertTo32Bits(_bitmap));
    }
    /// Converts an image to another format.
    /// Throws $(D ImageException) on error.
    /// Get Converted image.
    Bitmap convertToType(FREE_IMAGE_TYPE dstType, bool scaleLinear = true) {
        FIBITMAP* converted = FreeImage_ConvertToType(_bitmap, dstType, scaleLinear);
        if (converted is null) {
            throw new ImageException("disallowed conversion");
        }
        return new Bitmap(converted);
    }
    /// Converts an image to float format.
    /// Get Converted image.
    Bitmap convertToFloat() {
        return new Bitmap(FreeImage_ConvertToFloat(_bitmap));
    }
    /// Converts an image to RGBF format.
    /// Get Converted image.
    Bitmap convertToRGBF() {
        return new Bitmap(FreeImage_ConvertToRGBF(_bitmap));
    }
    /// Converts an image to UINT16 format.
    /// Get Converted image.
    Bitmap convertToUINT16() {
        return new Bitmap(FreeImage_ConvertToUINT16(_bitmap));
    }
    /// Converts an image to RGB16 format.
    /// Get Converted image.
    Bitmap convertToRGB16() {
        return new Bitmap(FreeImage_ConvertToRGB16(_bitmap));
    }
    /// Clones an image.
    /// Get Cloned image.
    Bitmap clone() {
        return new Bitmap(FreeImage_Clone(_bitmap));
    }
    /// Applies color quantization.
    Bitmap colorQuantize(FREE_IMAGE_QUANTIZE quantize) {
        return new Bitmap(FreeImage_ColorQuantize(_bitmap, quantize));
    }
    /// Applies tone-mapping operator.
    Bitmap toneMapDrago03(double gamma = 2.2, double exposure = 0.0) {
        return new Bitmap(FreeImage_TmoDrago03(_bitmap, gamma, exposure));
    }
    /// Rescales the image.
    Bitmap rescale(int dstWidth, int dstHeight, FREE_IMAGE_FILTER filter) {
        return new Bitmap(FreeImage_Rescale(_bitmap, dstWidth, dstHeight, filter));
    }
    /// Flips the image vertically.
    /// Throws $(D ImageException) on error.
    void horizontalFlip() {
        if (FreeImage_FlipHorizontal(_bitmap) == FALSE) {
            throw new ImageException("cannot flip image horizontally");
        }
    }
    /// Flips the image horizontally.
    /// Throws $(D ImageException) on error.
    void verticalFlip() {
        if (FreeImage_FlipVertical(_bitmap) == FALSE) {
            throw new ImageException("cannot flip image horizontally");
        }
    }
    /// Rotates the image.
    /// Get Rotated image.
    Bitmap rotate(double angle, void* bkColor = null) {
        return new Bitmap(FreeImage_Rotate(_bitmap, angle, bkColor));
    }
    ///
    uint numberOfChannels() {
        immutable uint bytespp = FreeImage_GetLine(_bitmap) / FreeImage_GetWidth(_bitmap);
        immutable uint samples = bytespp / imageType.sizeof;
        return samples;
    }
}