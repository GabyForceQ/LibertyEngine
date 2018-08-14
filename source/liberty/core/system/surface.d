/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/surface.d, _surface.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.system.surface;

import derelict.sdl2.sdl :
    SDL_Surface, SDL_PixelFormat, SDL_Rect,
    SDL_CreateRGBSurface, SDL_CreateRGBSurfaceFrom,
    SDL_FreeSurface, SDL_ConvertSurface, 
    SDL_LockSurface, SDL_UnlockSurface,
    SDL_GetRGBA, SDL_MapRGBA, SDL_SetColorKey,
    SDL_BlitSurface, SDL_BlitScaled;

import liberty.core.system.constants : Owned;
import liberty.core.system.platform : Platform;
import liberty.core.math.vector : Vector;

/**
 *
 */
final class Surface {

    private {
        SDL_Surface* _surface;
	    Platform _platform;
	    Owned _handleOwned;
    }

    /**
     *
     */
    this(Platform platform, SDL_Surface* surface, Owned owned) pure nothrow @trusted @nogc
    in {
        assert (surface !is null, "Surface is null!");
    } do {
        _platform = platform;
        _surface = surface;
        _handleOwned = owned;
    }

    /**
     *
     */
    this(Platform platform, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask) @trusted {
        _platform = platform;
        _surface = SDL_CreateRGBSurface(0, width, height, depth, Rmask, Gmask, Bmask, Amask);
        if (_surface is null) {
            _platform.throwPlatformException("SDL_CreateRGBSurface");
        }
        _handleOwned = Owned.Yes;
    }

    /**
     *
     */
    this(Platform platform, void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask) @trusted {
        _platform = platform;
        _surface = SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask);
        if (_surface is null) {
            _platform.throwPlatformException("SDL_CreateRGBSurfaceFrom");
        }
        _handleOwned = Owned.Yes;
    }

    ~this() nothrow @trusted {
        if (_surface !is null) {
            //debug import liberty.core.utils.memory : ensureNotInGC;
            //debug ensureNotInGC("Surface");
            if (_handleOwned == Owned.Yes) {
                SDL_FreeSurface(_surface);
            }
            _surface = null;
        }
    }

    /**
     *
     */
    Surface convert(const(SDL_PixelFormat)* newFormat) @trusted {
        SDL_Surface* surface = SDL_ConvertSurface(_surface, newFormat, 0);
        if (surface is null) {
            _platform.throwPlatformException("SDL_ConvertSurface");
        }
        assert (surface != _surface, "It should not be the same handle!");
        return new Surface(_platform, surface, Owned.Yes);
    }

    /**
     *
     */
    Surface clone() @safe {
        return convert(pixelFormat());
    }

    /**
     * Get surface width.
     */
    int width() pure nothrow const @safe @nogc @property {
        return _surface.w;
    }

    /**
     * Get surface height.
     */
    int height() pure nothrow const @safe @nogc @property {
        return _surface.h;
    }

    /**
     * Get surface pixels.
     */
    ubyte* pixels() pure nothrow const @trusted @nogc @property {
        return cast(ubyte*) _surface.pixels;
    }

    /**
     * Get surface pitch.
     */
    size_t pitch() pure nothrow const @safe @nogc @property {
        return _surface.pitch;
    }

    /**
     * Lock the surface.
     */
    void lock() @trusted {
        if (SDL_LockSurface(_surface) != 0) {
            _platform.throwPlatformException("SDL_LockSurface");
        }
    }

    /**
     * Unlock the surface.
     */
    void unlock() nothrow @trusted @nogc {
        SDL_UnlockSurface(_surface);
    }

    /**
     * Get surface pixel format.
     */
    SDL_PixelFormat* pixelFormat() pure nothrow @safe @nogc {
        return _surface.format;
    }

    /**
     *
     */
    Vector!(ubyte, 4) rgba(int x, int y) @trusted {
        if (x < 0 || x >= width()) {
            assert(0, "Out of image!");
        }
        if (y < 0 || y >= height()) {
            assert(0, "Out of image!");
        }
        SDL_PixelFormat* fmt = _surface.format;
        ubyte* pixels = cast(ubyte*)_surface.pixels;
        immutable int pitch = _surface.pitch;
        uint* pixel = cast(uint*)(pixels + y * pitch + x * fmt.BytesPerPixel);
        ubyte r, g, b, a;
        SDL_GetRGBA(*pixel, fmt, &r, &g, &b, &a);
        return Vector!(ubyte, 4)(r, g, b, a);
    }

    /**
     *
     */
    void setColorKey(bool enable, uint key) @trusted {
        if (0 != SDL_SetColorKey(this._surface, enable ? true : false, key)) {
            _platform.throwPlatformException("SDL_SetColorKey");
        }
    }

    /**
     *
     */
    void setColorKey(bool enable, ubyte r, ubyte g, ubyte b, ubyte a = 0) @trusted {
        uint key = SDL_MapRGBA(cast(const)this._surface.format, r, g, b, a);
        this.setColorKey(enable, key);
    }

    /**
     *
     */
    void blit(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) @trusted {
        if (0 != SDL_BlitSurface(source._surface, &srcRect, _surface, &dstRect)) {
            _platform.throwPlatformException("SDL_BlitSurface");
        }
    }
    
    /**
     *
     */
    void blitScaled(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) @trusted {
        if (0 != SDL_BlitScaled(source._surface, &srcRect, _surface, &dstRect)) {
            _platform.throwPlatformException("SDL_BlitScaled");
        }
    }

    package SDL_Surface* handle() pure nothrow @safe @nogc {
        return _surface;
    }

}