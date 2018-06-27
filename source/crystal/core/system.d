/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.system;
import crystal.core.input;
import derelict.util.exception;
import derelict.util.loader;
import derelict.sdl2.sdl;
import crystal.core.memory : ensureNotInGC;
import std.string : format, fromStringz, toStringz;
/// A failing Platform function should <b>always</b> throw a $(D PlatformException).
final class PlatformException : Exception {
    /// Default constructor.
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
        super(msg, file, line, next);
    }
}
/// Root object for SDL2 functionality.
/// It's passed around to other SDL wapper objects to ensure library loading.
final class Platform {
    private {
        bool _initialized;
        SDL2Window[uint] _knownWindows;
        bool _shouldQuit;
    }
    package void throwPlatformException(string call_name) {
        string message = format("%s failed: %s", call_name, getErrorString());
        throw new PlatformException(message);
    }
    /// Returns last SDL error and clears it.
    const(char)[] getErrorString() {
        const(char)* message = SDL_GetError();
        SDL_ClearError();
        return fromStringz(message);
    }
    /// Load SDL2 library.
    /// Param1: You can specify a minimum version of SDL2 for your application.
    this(SharedLibVersion sld2_version = SharedLibVersion(2, 0, 6)) {
        try {
            DerelictSDL2.load(sld2_version);
        } catch (DerelictException e) {
            throw new PlatformException(e.msg);
        }
        if (SDL_Init(0)) {
            throwPlatformException("SDL_Init");
        }
        Input.startService();
    }
    /// Releases all resourceas and the SDL library.
    ~this() {
        if (_initialized) {
            debug ensureNotInGC("Platform");
            SDL_Quit();
            _initialized = false;
        }
    }
    /// Returns available SDL video drivers.
    alias getVideoDrivers = getDrivers!(SDL_GetNumVideoDrivers, SDL_GetVideoDriver);
    /// Returns available SDL audio drivers.
    alias getAudioDrivers = getDrivers!(SDL_GetNumAudioDrivers, SDL_GetAudioDriver);
    /// Returns true if a subsystem is initiated.
    bool subSystemInitialized(int sub_system) {
        int inited = SDL_WasInit(SDL_INIT_EVERYTHING);
        return (inited & sub_system) != 0;
    }
    /// Initialize a subsystem.
    void subSystemInit(int flag) {
        if (!subSystemInitialized(flag)) {
            if (SDL_InitSubSystem(flag)) {
                throwPlatformException("SDL_InitSubSystem");
            }
        }
    }
    /// Returns available display information.
    /// Throws $(D PlatformException) on error.
    SDL2VideoDisplay[] getDisplays() {
        int displatyCount = SDL_GetNumVideoDisplays();
        SDL2VideoDisplay[] availableDisplays;
        for (int displayIndex = 0; displayIndex < displatyCount; displayIndex++) {
            SDL_Rect rect;
            int res = SDL_GetDisplayBounds(displayIndex, &rect);
            if (res) {
                throwPlatformException("SDL_GetDisplayBounds");
            }
            SDL2DisplayMode[] availableModes;
            int modeCount = SDL_GetNumDisplayModes(displayIndex);
            for (int modeIndex = 0; modeIndex < modeCount; modeIndex++) {
                SDL_DisplayMode mode;
                if (SDL_GetDisplayMode(displayIndex, modeIndex, &mode)) {
                    throwPlatformException("SDL_GetDisplayMode");
                }
                availableModes ~= new SDL2DisplayMode(modeIndex, mode);
            }
            availableDisplays ~= new SDL2VideoDisplay(displayIndex, rect, availableModes);
        }
        return availableDisplays;
    }
    /// Returns resolution of the first display.
    /// Throws $(D PlatformException) on error.
    SDL_Point firstDisplayResolution() {
        auto displays = getDisplays();
        if (displays.length == 0) {
            throw new PlatformException("No display");
        }
        return displays[0].dimension();
    }
    /// Returns resolution of the second display.
    /// Throws $(D PlatformException) on error.
    SDL_Point secondDisplayResolution() {
        auto displays = getDisplays();
        if (displays.length == 0) {
            throw new PlatformException("No display");
        } else if (displays.length == 1) {
            return SDL_Point(0, 0);
        }
        return displays[1].dimension();
    }
    /// Get next SDL2 event.
    /// Input state gets updated and window callbacks are called too.
    /// Returns true if an event is returned.
    bool pollEvent(SDL_Event* event) {
        if (!SDL_PollEvent(event)) {
            updateState(event);
            return true;
        }
        return false;
    }
    /// Wait for next SDL2 event.
    /// Input state gets updated and window callbacks are called too.
    /// Throws $(D PlatformException) on error.
    void waitEvent(SDL_Event* event) {
        if (!SDL_WaitEvent(event)) {
            throwPlatformException("SDL_WaitEvent");
        }
        updateState(event);
    }
    /// Wait for next SDL2 event, with a timeout.
    /// Input state gets updated and window callbacks are called too.
    /// Returns true if an event is returned.
    /// Throws $(D PlatformException) on error.
    bool waitEventTimeout(SDL_Event* event, int timeout_ms) {
        if (SDL_WaitEventTimeout(event, timeout_ms) == 1) {
            updateState(event);
            return true;
        }
        return false;
    }
    /// Process all pending SDL2 events.
    /// Input state gets updated.
    void processEvents() {
        SDL_Event event;
        while(SDL_PollEvent(&event)) {
            updateState(&event);
            if (event.type == SDL_QUIT) {
                _shouldQuit = true;
            }
        }
    }
    /// Returns true if application should quit.
    bool getShouldQuit () pure nothrow const {
        return _shouldQuit;
    }
    /// Start text input.
    void startTextInput() {
        SDL_StartTextInput();
    }
    /// Stops text input.
    void stopTextInput() {
        SDL_StopTextInput();
    }
    /// Sets clipboard content.
    /// Throws $(D PlatformException) on error.
    string setClipboard(string s) {
        if (SDL_SetClipboardText(toStringz(s))) {
            throwPlatformException("SDL_SetClipboardText");
        }
        return s;
    }
    /// Returns clipboard content.
    /// Throws $(D PlatformException) on error.
    const(char)[] getClipboard() {
        if (SDL_HasClipboardText() == SDL_FALSE) {
            return null;
        }
        const(char)* s = SDL_GetClipboardText();
        if (s is null) {
            throwPlatformException("SDL_GetClipboardText");
        }
        return fromStringz(s);
    }
    /// Returns available audio device names.
    const(char)[][] getAudioDevices() {
        enum type = 0;
        const(int) devicesCount = SDL_GetNumAudioDevices(type);
        const(char)[][] ret;
        foreach (i; 0 .. devicesCount) {
            ret ~= fromStringz(SDL_GetAudioDeviceName(i, type));
        }
        return ret;
    }
    /// Returns platform name.
    const(char)[] getPlatformName() {
        return fromStringz(SDL_GetPlatform());
    }
    /// Returns L1 cacheline size in bytes.
    int getL1LineSize() {
        int ret = SDL_GetCPUCacheLineSize();
        if (ret <= 0) {
            ret = 64;
        }
        return ret;
    }
    /// Returns number of CPUs
    int getCPUCount() {
        int ret = SDL_GetCPUCount();
        if (ret <= 0) {
            ret = 1;
        }
        return ret;
    }
    /// Returns a path suitable for writing configuration files.
    /// Throws $(D PlatformException) on error.
    const(char)[] getPrefPath(string org_name, string application_name) {
        char* basePath = SDL_GetPrefPath(toStringz(org_name), toStringz(application_name));
        if (basePath !is null) {
            const(char)[] result = fromStringz(basePath);
            SDL_free(basePath);
            return result;
        }
        throwPlatformException("SDL_GetPrefPath");
        return null;
    }
    private const(char)[][] getDrivers(alias numFn, alias elemFn)() {
        const(int) numDrivers = numFn();
        const(char)[][] res;
        res.length = numDrivers;
        foreach (i; 0..numDrivers) {
            res[i] = fromStringz(elemFn(i));
        }
        return res;
    }
    private void updateState(const(SDL_Event*) event) {
        switch(event.type) {
            case SDL_QUIT:
                _shouldQuit = true;
                break;
            case SDL_KEYDOWN:
            case SDL_KEYUP:
                updateKeyboard(&event.key);
                break;
            case SDL_MOUSEMOTION:
                Input.updateMouseMotion(&event.motion);
                Input._isMouseMoving = true;
                break;
            case SDL_MOUSEBUTTONUP:
            case SDL_MOUSEBUTTONDOWN:
                Input.updateMouseButtons(&event.button);
                break;
            case SDL_MOUSEWHEEL:
                Input.updateMouseWheel(&event.wheel);
                Input._isMouseWheeling = true;
                break;
            default:
                break;
        }
    }

    private void updateKeyboard(const(SDL_KeyboardEvent*) event) {
        if (event.repeat != 0) {
            return;
        }
        switch (event.type) {
            case SDL_KEYDOWN:
                assert(event.state == SDL_PRESSED);
                Input.markKeyAsPressed(event.keysym.scancode);
                break;
            case SDL_KEYUP:
                assert(event.state == SDL_RELEASED);
                Input.markKeyAsJustReleased(event.keysym.scancode);
                break;
            default:
                break;
        }
    }
}
///
final class SDL2DisplayMode {
    private int _modeIndex;
    private SDL_DisplayMode _mode;
    ///
    this(int index, SDL_DisplayMode mode) {
        _modeIndex = index;
        _mode = mode;
    }
    ///
    override string toString() {
        return format("mode #%s (width = %spx, height = %spx, rate = %shz, format = %s)",
            _modeIndex, _mode.w, _mode.h, _mode.refresh_rate, _mode.format);
    }
}
///
final class SDL2VideoDisplay {
    private {
        int _displayIndex;
        SDL2DisplayMode[] _availableModes;
        SDL_Rect _bounds;
    }
    ///
    this(int index, SDL_Rect bounds, SDL2DisplayMode[] available_mods) {
        _displayIndex = index;
        _bounds = bounds;
        _availableModes = _availableModes;
    }
    ///
    const(SDL2DisplayMode[]) availableModes() pure const nothrow {
        return _availableModes;
    }
    ///
    SDL_Point dimension() pure const nothrow {
        return SDL_Point(_bounds.w, _bounds.h);
    }
    SDL_Rect bounds() pure const nothrow {
        return _bounds;
    }
    override string toString() {
        string res = format("display #%s (start = %s,%s - dimension = %s x %s)\n", _displayIndex,
                            _bounds.x, _bounds.y, _bounds.w, _bounds.h);
        foreach (mode; _availableModes) {
            res ~= format("  - %s\n", mode);
        }
        return res;
    }
}
/// SDL2Window class.
final class SDL2Window {
    private {
        Surface _surface;
        SDL2GLContext _glContext;
        uint _id;
        bool _surfaceNeedRenew;
        bool _hasValidSurface() { return !_surfaceNeedRenew && _surface !is null; }
    }
    SDL2GLContext getGLContext() {
        return _glContext;
    }
    //package {
    Platform _platform;
    SDL_Window* _window;
    //}
    /// Construct a window using an Platform reference and.
    this(Platform platform, int x, int y, int width, int height, SDL_WindowFlags flags) {
        _platform = platform;
        _surface = null;
        _glContext = null;
        _surfaceNeedRenew = false;
        bool open_gl = (flags & SDL_WINDOW_OPENGL) != 0;
        ////
        width = 1600;
        height = 900;
        //flags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
        //flags |= SDL_WINDOW_BORDERLESS;
        flags |= SDL_WINDOW_ALLOW_HIGHDPI;
        flags |= SDL_WINDOW_RESIZABLE;
        // TODO: Try removing SDL_HWSURFACE from your SDL_SetVideoMode() flags.
        ////
        _window = SDL_CreateWindow(toStringz(""), x, y, width, height, flags);
        if (_window == null) {
            string message = "SDL_CreateWindow failed: " ~ _platform.getErrorString().idup;
            throw new PlatformException(message);
        }
        _id = SDL_GetWindowID(_window);
        if (open_gl) {
            _glContext = new SDL2GLContext(this);
        }

        //SDL_Surface *surface;     // Declare an SDL_Surface to be filled in with pixel data from an image file
        //import std.conv: to;
        //Uint16[16*16] pixels = windowIcon.ptr;
        //surface = SDL_CreateRGBSurfaceFrom(pixels.ptr,16,16,16,16*2,0x0f00,0x00f0,0x000f,0xf000);
        //SDL_SetWindowIcon(_window, surface);
        //SDL_FreeSurface(surface);
	    
        
    }
    /// Construct a window using an Platform reference and.
    this(Platform platform, void* windowData) {
        _platform = platform;
        _surface = null;
        _glContext = null;
        _surfaceNeedRenew = false;
        _window = SDL_CreateWindowFrom(windowData);
        if (_window == null) {
            string message = "SDL_CreateWindowFrom failed: " ~ _platform.getErrorString().idup;
            throw new PlatformException(message);
        }
        _id = SDL_GetWindowID(_window);
    }
    /// Releases the SDL2 resource.
    ~this() {
        if (_glContext !is null) {
	        debug import crystal.core.memory : ensureNotInGC;
	        debug ensureNotInGC("SDL2Window");
	        _glContext.destroy();
	        _glContext = null;
        }
        if (_window !is null)
        {
            debug import crystal.core.memory : ensureNotInGC;
            debug ensureNotInGC("SDL2Window");
            SDL_DestroyWindow(_window);
            _window = null;
        }
    }
    
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowFullscreen)
    /// Throws: $(D PlatformException) on error.
    final void setFullscreenSetting(uint flags) {
        if (SDL_SetWindowFullscreen(_window, flags) != 0) {
	        _platform.throwPlatformException("SDL_SetWindowFullscreen");
        }
    }
    
    /// Returns: The flags associated with the window.
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_GetWindowFlags)
    final uint getWindowFlags() {
        return SDL_GetWindowFlags(_window);
    }
    /// Returns: X window coordinate.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowPosition)
    final int getX() {
        return getPosition().x;
    }
    /// Returns: Y window coordinate.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowPosition)
    final int getY() {
        return getPosition().y;
    }
    /// Gets information about the window's display mode
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_GetWindowDisplayMode)
    final SDL_DisplayMode getWindowDisplayMode() {
        SDL_DisplayMode mode;
        if (0 != SDL_GetWindowDisplayMode(_window, &mode)) {
	        _platform.throwPlatformException("SDL_GetWindowDisplayMode");
        }
        return mode;
    }
    /// Returns: Window coordinates.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowPosition)
    final SDL_Point getPosition() {
        int x, y;
        SDL_GetWindowPosition(_window, &x, &y);
        return SDL_Point(x, y);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowPosition)
    final void setPosition(int positionX, int positionY) {
        SDL_SetWindowPosition(_window, positionX, positionY);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowSize)
    final void setSize(int width, int height) {
        SDL_SetWindowSize(_window, width, height);
    }
    /// Get the minimum size setting for the window
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_GetWindowMinimumSize)
    final SDL_Point getMinimumSize() {
        SDL_Point p;
        SDL_GetWindowMinimumSize(_window, &p.x, &p.y);
        return p;
    }
    /// Get the minimum size setting for the window
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_SetWindowMinimumSize)
    final void setMinimumSize(int width, int height) {
        SDL_SetWindowMinimumSize(_window, width, height);
    }
    /// Get the minimum size setting for the window
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_GetWindowMaximumSize)
    final SDL_Point getMaximumSize() {
        SDL_Point p;
        SDL_GetWindowMaximumSize(_window, &p.x, &p.y);
        return p;
    }
    /// Get the minimum size setting for the window
    /// See_also: $(LINK https://wiki.libsdl.org/SDL_SetWindowMaximumSize)
    final void setMaximumSize(int width, int height) {
        SDL_SetWindowMaximumSize(_window, width, height);
    }
    
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowSize)
    /// Returns: Window size in pixels.
    import crystal.math.vector;
    final Vector2I getSize() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return Vector2I(w, h);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowIcon)
    final void setIcon(Surface icon) {
        SDL_SetWindowIcon(_window, icon.handle());
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowBordered)
    final void setBordered(bool bordered) {
        SDL_SetWindowBordered(_window, bordered ? SDL_TRUE : SDL_FALSE);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowSize)
    /// Returns: Window width in pixels.
    final int getWidth() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return w;
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowSize)
    /// Returns: Window height in pixels.
    final int getHeight() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return h;
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_SetWindowTitle)
    final void setTitle(string title) {
        SDL_SetWindowTitle(_window, toStringz(title));
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_ShowWindow)
    final void show() {
        SDL_ShowWindow(_window);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_HideWindow)
    final void hide() {
        SDL_HideWindow(_window);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_MinimizeWindow)
    final void minimize() {
        SDL_MinimizeWindow(_window);
    }
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_MaximizeWindow)
    final void maximize() {
        SDL_MaximizeWindow(_window);
    }
    /// Returns: Window surface.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowSurface)
    /// Throws: $(D PlatformException) on error.
    final Surface surface() {
        if (!_hasValidSurface()) {
            SDL_Surface* internalSurface = SDL_GetWindowSurface(_window);
            if (internalSurface is null) {
	            _platform.throwPlatformException("SDL_GetWindowSurface");
            }
            _surfaceNeedRenew = false;
            _surface = new Surface(_platform, internalSurface,  Surface.Owned.No);
        }
        return _surface;
    }
    /// Submit changes to the window surface.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_UpdateWindowSurface)
    /// Throws: $(D PlatformException) on error.
    final void updateSurface() {
        if (!_hasValidSurface()) {
	        surface();
        }
        int res = SDL_UpdateWindowSurface(_window);
        if (res != 0) {
	        _platform.throwPlatformException("SDL_UpdateWindowSurface");
        }
    }
    /// Returns: Window ID.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowID)
    final int id() {
        return _id;
    }
    /// Returns: System-specific window information, useful to use a third-party rendering library.
    /// See_also: $(LINK http://wiki.libsdl.org/SDL_GetWindowWMInfo)
    /// Throws: $(D PlatformException) on error.
    SDL_SysWMinfo getWindowInfo() {
        SDL_SysWMinfo info;
        SDL_VERSION(&info.version_);
        int res = SDL_GetWindowWMInfo(_window, &info);
        if (res != SDL_TRUE) {
	        _platform.throwPlatformException("SDL_GetWindowWMInfo");
        }
        return info;
    }
}
///
final class SDL2GLContext {
	package {
		SDL_GLContext _context;
		SDL2Window _window;
	}
	private {
		bool _initialized;
	}
    /// Creates an OpenGL context for a given SDL window.
    this(SDL2Window window) {
        _window = window;
        _context = SDL_GL_CreateContext(window._window);
        _initialized = true;
    }
    ///
    ~this() {
        close();
    }
    
    /// Release the associated SDL ressource.
    void close() {
        if (_initialized) {
            _initialized = false;
        }
    }
    /// Makes this OpenGL context current.
    /// Throws: $(D PlatformException) on error.
    void makeCurrent() {
        if (0 != SDL_GL_MakeCurrent(_window._window, _context)) {
	        _window._platform.throwPlatformException("SDL_GL_MakeCurrent");
        }
    }
}
///
final class Surface {
    package {
	    Platform _platform;
	    SDL_Surface* _surface;
	    Owned _handleOwned;
    }
    ///
    enum Owned : byte {
        ///
        No = 0x00,
        ///
        Yes = 0x01
    }
    ///
    this(Platform platform, SDL_Surface* surface, Owned owned) {
        assert(surface !is null);
        _platform = platform;
        _surface = surface;
        _handleOwned = owned;
    }
    ///
    this(Platform platform, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask) {
        _platform = platform;
        _surface = SDL_CreateRGBSurface(0, width, height, depth, Rmask, Gmask, Bmask, Amask);
        if (_surface is null)
            _platform.throwPlatformException("SDL_CreateRGBSurface");
        _handleOwned = Owned.Yes;
    }
    ///
    this(Platform platform, void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask) {
        _platform = platform;
        _surface = SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask);
        if (_surface is null)
            _platform.throwPlatformException("SDL_CreateRGBSurfaceFrom");
        _handleOwned = Owned.Yes;
    }
    ///
    ~this(){
        if (_surface !is null) {
            debug import crystal.core.memory : ensureNotInGC;
            debug ensureNotInGC("Surface");
            if (_handleOwned == Owned.Yes)
                SDL_FreeSurface(_surface);
            _surface = null;
        }
    }
    ///
    Surface convert(const(SDL_PixelFormat)* newFormat) {
        SDL_Surface* surface = SDL_ConvertSurface(_surface, newFormat, 0);
        if (surface is null)
            _platform.throwPlatformException("SDL_ConvertSurface");
        assert(surface != _surface); // should not be the same handle
        return new Surface(_platform, surface, Owned.Yes);
    }
    ///
    Surface clone() {
        return convert(pixelFormat());
    }
    
    ///
    @property int width() const {
        return _surface.w;
    }
    
    ///
    @property int height() const {
        return _surface.h;
    }
    ///
    ubyte* pixels() {
        return cast(ubyte*) _surface.pixels;
    }
    ///
    size_t pitch() {
        return _surface.pitch;
    }
    ///
    void lock() {
        if (SDL_LockSurface(_surface) != 0)
            _platform.throwPlatformException("SDL_LockSurface");
    }
    ///
    void unlock() {
        SDL_UnlockSurface(_surface);
    }
    
    ///
    SDL_Surface* handle() {
        return _surface;
    }
    
    ///
    SDL_PixelFormat* pixelFormat()
    {
        return _surface.format;
    }
    
    ///
    struct RGBA
    {
        ubyte r, g, b, a;
    }
    ///
    RGBA getRGBA(int x, int y) {
        // crash if out of image, todo: exception
        if (x < 0 || x >= width())
            assert(0);
        if (y < 0 || y >= height())
            assert(0);
        SDL_PixelFormat* fmt = _surface.format;
        ubyte* pixels = cast(ubyte*)_surface.pixels;
        int pitch = _surface.pitch;
        uint* pixel = cast(uint*)(pixels + y * pitch + x * fmt.BytesPerPixel);
        ubyte r, g, b, a;
        SDL_GetRGBA(*pixel, fmt, &r, &g, &b, &a);
        return RGBA(r, g, b, a);
    }
    ///
    void setColorKey(bool enable, uint key) {
        if (0 != SDL_SetColorKey(this._surface, enable ? SDL_TRUE : SDL_FALSE, key))
            _platform.throwPlatformException("SDL_SetColorKey");
    }
    ///
    void setColorKey(bool enable, ubyte r, ubyte g, ubyte b, ubyte a = 0) {
        uint key = SDL_MapRGBA(cast(const)this._surface.format, r, g, b, a);
        this.setColorKey(enable, key);
    }
    ///
    void blit(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) {
        if (0 != SDL_BlitSurface(source._surface, &srcRect, _surface, &dstRect))
            _platform.throwPlatformException("SDL_BlitSurface");
    }
    ///
    void blitScaled(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) {
        if (0 != SDL_BlitScaled(source._surface, &srcRect, _surface, &dstRect))
            _platform.throwPlatformException("SDL_BlitScaled");
    }
}
///
class Timer {
    private SDL_TimerID _id;
    /// Create a new timer.
    this(Platform platform, uint intervalMs) {
        _id = SDL_AddTimer(intervalMs, &timerCallbackSDL, cast(void*)this);
        if (_id == 0) {
            platform.throwPlatformException("SDL_AddTimer");
        }
    }
    /// Returns timer id.
    int id() pure const nothrow {
        return _id;
    }
    ~this() {
        if (_id != 0) {
            import crystal.core.memory : ensureNotInGC;
            debug ensureNotInGC("SDL2Timer");
            SDL_RemoveTimer(_id);
            _id = 0;
        }
    }
    ///
    protected abstract uint onTimer(uint interval) nothrow;
}
extern(C) private uint timerCallbackSDL(uint interval, void* param) nothrow {
    try {
        Timer timer = cast(Timer)param;
        return timer.onTimer(interval);
    } catch (Throwable e) {
        import core.stdc.stdlib : exit;
        exit(-1);
        return 0;
    }
}