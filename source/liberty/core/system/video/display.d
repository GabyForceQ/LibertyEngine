module liberty.core.system.video.display;

import derelict.sdl2.sdl :
  SDL_DisplayMode, SDL_Rect, SDL_Point;

/**
 *
**/
final class DisplayMode {
  private {
    int _modeIndex;
    SDL_DisplayMode _mode;
  }

  /**
   *
  **/
  this(int index, SDL_DisplayMode mode) {
    _modeIndex = index;
    _mode = mode;
  }
  
  /**
   *
  **/
  override string toString() const {
    import std.format : format;
    return format(
      "mode #%s (width = %spx, height = %spx, rate = %shz, format = %s)",
      _modeIndex, 
      _mode.w, 
      _mode.h, 
      _mode.refresh_rate, 
      _mode.format
    );
  }
}

/**
 *
 */
final class VideoDisplay {
  private {
    int _displayIndex;
    DisplayMode[] _availableModes;
    SDL_Rect _bounds;
  }

  /**
   *
  **/
  this(int index, SDL_Rect bounds, DisplayMode[] available_mods) {
    _displayIndex = index;
    _bounds = bounds;
    _availableModes = _availableModes;
  }

  /**
   *
  **/
  const(DisplayMode[]) availableModes() pure nothrow const @safe {
    return _availableModes;
  }

  /**
   *
  **/
  SDL_Point dimension() pure nothrow const @safe {
    return SDL_Point(_bounds.w, _bounds.h);
  }

  /**
   *
  **/
  SDL_Rect bounds() pure nothrow const @safe {
    return _bounds;
  }

  /**
   *
  **/
  override string toString() const {
    import std.format : format;
    string res = format(
      "display #%s (start = %s,%s - dimension = %s x %s)\n", 
      _displayIndex, 
      _bounds.x, 
      _bounds.y, 
      _bounds.w, 
      _bounds.h
    );
    foreach (mode; _availableModes) {
      res ~= format("  - %s\n", mode);
    }
    return res;
  }
}