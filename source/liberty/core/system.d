/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system.d, _system.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.system;
import liberty.core.input;
import derelict.util.exception;
import derelict.util.loader;
import derelict.sdl2.sdl;
import liberty.core.memory : ensureNotInGC;
import liberty.math.vector : Vector, Vector2I;
import std.string : format, fromStringz, toStringz;
/// A failing Platform function should <b>always</b> throw a $(D PlatformException).
final class PlatformException : Exception {
    /// Default constructor.
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) @safe {
        super(msg, file, line, next);
        import liberty.core.logger : Logger;
        import std.conv : to;
        Logger.get.exception("Message: '" ~ msg ~ "'; File: '" ~ file ~ "'; Line:'" ~ line.to!string ~ "'.");
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
        string message = format("%s failed: %s", call_name, errorString());
        throw new PlatformException(message);
    }
    /// Returns last SDL error and clears it.
    const(char)[] errorString() {
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
        InputNova.get.startService();
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
    alias videoDrivers = drivers!(SDL_GetNumVideoDrivers, SDL_GetVideoDriver);
    /// Returns available SDL audio drivers.
    alias audioDrivers = drivers!(SDL_GetNumAudioDrivers, SDL_GetAudioDriver);
    /// Returns true if a subsystem is initiated.
    bool subSystemInitialized(int sub_system) {
        immutable int inited = SDL_WasInit(SDL_INIT_EVERYTHING);
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
    SDL2VideoDisplay[] displays() {
        immutable int displatyCount = SDL_GetNumVideoDisplays();
        SDL2VideoDisplay[] availableDisplays;
        for (int displayIndex; displayIndex < displatyCount; displayIndex++) {
            SDL_Rect rect;
            immutable int res = SDL_GetDisplayBounds(displayIndex, &rect);
            if (res) {
                throwPlatformException("SDL_GetDisplayBounds");
            }
            SDL2DisplayMode[] availableModes;
            immutable int modeCount = SDL_GetNumDisplayModes(displayIndex);
            for (int modeIndex; modeIndex < modeCount; modeIndex++) {
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
        auto displays = displays();
        if (displays.length == 0) {
            throw new PlatformException("No display");
        }
        return displays[0].dimension();
    }
    /// Returns resolution of the second display.
    /// Throws $(D PlatformException) on error.
    SDL_Point secondDisplayResolution() {
        auto displays = displays();
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
    bool shouldQuit () pure nothrow const {
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
    string clipboard(string s) {
        if (SDL_SetClipboardText(toStringz(s))) {
            throwPlatformException("SDL_SetClipboardText");
        }
        return s;
    }
    /// Returns clipboard content.
    /// Throws $(D PlatformException) on error.
    const(char)[] clipboard() {
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
    const(char)[][] audioDevices() {
        enum type = 0;
        const(int) devicesCount = SDL_GetNumAudioDevices(type);
        const(char)[][] ret;
        foreach (i; 0 .. devicesCount) {
            ret ~= fromStringz(SDL_GetAudioDeviceName(i, type));
        }
        return ret;
    }
    /// Returns platform name.
    const(char)[] platformName() {
        return fromStringz(SDL_GetPlatform());
    }
    /// Returns L1 cacheline size in bytes.
    int l1LineSize() {
        int ret = SDL_GetCPUCacheLineSize();
        if (ret <= 0) {
            ret = 64;
        }
        return ret;
    }
    /// Returns number of CPUs
    int cpuCount() {
        int ret = SDL_GetCPUCount();
        if (ret <= 0) {
            ret = 1;
        }
        return ret;
    }
    /// Returns a path suitable for writing configuration files.
    /// Throws $(D PlatformException) on error.
    const(char)[] prefPath(string org_name, string application_name) {
        char* basePath = SDL_GetPrefPath(toStringz(org_name), toStringz(application_name));
        if (basePath !is null) {
            const(char)[] result = fromStringz(basePath);
            SDL_free(basePath);
            return result;
        }
        throwPlatformException("SDL_GetPrefPath");
        return null;
    }
    private const(char)[][] drivers(alias numFn, alias elemFn)() {
        const(int) numDrivers = numFn();
        const(char)[][] res;
        res.length = numDrivers;
        foreach (i; 0..numDrivers) {
            res[i] = fromStringz(elemFn(i));
        }
        return res;
    }
    private void updateState(const(SDL_Event*) event) {
        InputNova.get.update(0.0f);
        switch(event.type) {
            case SDL_QUIT:
                _shouldQuit = true;
                break;
            case SDL_KEYDOWN:
            case SDL_KEYUP:
                updateKeyboard(&event.key);
                break;
            case SDL_MOUSEMOTION:
                Input.get.updateMouseMotion(&event.motion);
                Input.get._isMouseMoving = true;
                break;
            case SDL_MOUSEBUTTONUP:
            case SDL_MOUSEBUTTONDOWN:
                Input.get.updateMouseButtons(&event.button);
                break;
            case SDL_MOUSEWHEEL:
                Input.get.updateMouseWheel(&event.wheel);
                Input.get._isMouseWheeling = true;
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
                Input.get.markKeyAsPressed(event.keysym.scancode);
                break;
            case SDL_KEYUP:
                assert(event.state == SDL_RELEASED);
                Input.get.markKeyAsJustReleased(event.keysym.scancode);
                break;
            default:
                break;
        }
    }
}
///
final class SDL2DisplayMode {
    private {
        int _modeIndex;
        SDL_DisplayMode _mode;
    }
    ///
    this(int index, SDL_DisplayMode mode) {
        _modeIndex = index;
        _mode = mode;
    }
    ///
    override string toString() const {
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
    const(SDL2DisplayMode[]) availableModes() pure nothrow const @safe @nogc @property {
        return _availableModes;
    }
    ///
    SDL_Point dimension() pure nothrow const @safe @nogc @property {
        return SDL_Point(_bounds.w, _bounds.h);
    }
    ///
    SDL_Rect bounds() pure nothrow const @safe @nogc @property {
        return _bounds;
    }
    ///
    override string toString() const {
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
        SDL2VideoContext _videoContext;
        uint _id;
        bool _surfaceNeedRenew;
        bool _hasValidSurface() { return !_surfaceNeedRenew && _surface !is null; }
    }
    ///
    SDL2VideoContext videoContext() {
        return _videoContext;
    }
    ///
    Platform _platform;
    ///
    SDL_Window* _window;
    /// Construct a window using an Platform reference and.
    this(Platform platform, int x, int y, int width, int height, SDL_WindowFlags flags) {
        import liberty.core.logger : Logger;
        _platform = platform;
        _surface = null;
        _videoContext = null;
        _surfaceNeedRenew = false;
        version (__OpenGL__) {
            if (flags & SDL_WINDOW_OPENGL) {
                Logger.get.error("No OpenGL context available in OpenGL mode!");
            }
        }
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
            string message = "SDL_CreateWindow failed: " ~ _platform.errorString.idup;
            throw new PlatformException(message);
        }
        _id = SDL_GetWindowID(_window);
        _videoContext = new SDL2VideoContext(this);
    }
    /// Construct a window using an Platform reference and.
    this(Platform platform, void* windowData) {
        _platform = platform;
        _surface = null;
        _videoContext = null;
        _surfaceNeedRenew = false;
        _window = SDL_CreateWindowFrom(windowData);
        if (_window == null) {
            string message = "SDL_CreateWindowFrom failed: " ~ _platform.errorString.idup;
            throw new PlatformException(message);
        }
        _id = SDL_GetWindowID(_window);
    }
    /// Releases the SDL2 resource.
    ~this() {
        if (_videoContext !is null) {
	        debug import liberty.core.memory : ensureNotInGC;
	        debug ensureNotInGC("SDL2Window");
	        _videoContext.destroy();
	        _videoContext = null;
        }
        if (_window !is null)
        {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("SDL2Window");
            SDL_DestroyWindow(_window);
            _window = null;
        }
    }
    /// Throws $(D PlatformException) on error.
    void setFullscreenSetting(uint flags) {
        if (SDL_SetWindowFullscreen(_window, flags) != 0) {
	        _platform.throwPlatformException("SDL_SetWindowFullscreen");
        }
    }
    /// Get the flags associated with the window.
    uint windowFlags() {
        return SDL_GetWindowFlags(_window);
    }
    /// Get x window coordinate.
    int x() nothrow @safe @nogc {
        return position.x;
    }
    /// Get y window coordinate.
    int y() nothrow @safe @nogc {
        return position.y;
    }
    /// Get information about the window's display mode
    SDL_DisplayMode windowDisplayMode() {
        SDL_DisplayMode mode;
        if (0 != SDL_GetWindowDisplayMode(_window, &mode)) {
	        _platform.throwPlatformException("SDL_GetWindowDisplayMode");
        }
        return mode;
    }
    /// Get window coordinates.
    SDL_Point position() nothrow @trusted @nogc {
        int x, y;
        SDL_GetWindowPosition(_window, &x, &y);
        return SDL_Point(x, y);
    }
    /// Set window position.
    void position(int positionX, int positionY) {
        SDL_SetWindowPosition(_window, positionX, positionY);
    }
    /// Set window size.
    void size(int width, int height) {
        SDL_SetWindowSize(_window, width, height);
    }
    /// Get the minimum size setting for the window.
    SDL_Point minimumSize() {
        SDL_Point p;
        SDL_GetWindowMinimumSize(_window, &p.x, &p.y);
        return p;
    }
    /// Get the minimum size setting for the window.
    void minimumSize(int width, int height) {
        SDL_SetWindowMinimumSize(_window, width, height);
    }
    /// Get the minimum size setting for the window.
    SDL_Point maximumSize() {
        SDL_Point p;
        SDL_GetWindowMaximumSize(_window, &p.x, &p.y);
        return p;
    }
    /// Get the minimum size setting for the window.
    void maximumSize(int width, int height) {
        SDL_SetWindowMaximumSize(_window, width, height);
    }
    /// Get window size in pixels.
    Vector2I size() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return Vector2I(w, h);
    }
    /// Set window icon.
    void icon(Surface icon) {
        SDL_SetWindowIcon(_window, icon.handle());
    }
    /// Set if window is bordered.
    void isBordered(bool bordered) {
        SDL_SetWindowBordered(_window, bordered ? SDL_TRUE : SDL_FALSE);
    }
    /// Get indow width in pixels.
    int width() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return w;
    }
    /// Get window height in pixels.
    int height() {
        int w, h;
        SDL_GetWindowSize(_window, &w, &h);
        return h;
    }
    /// Set window title.
    void title(string title) {
        SDL_SetWindowTitle(_window, toStringz(title));
    }
    /// Show window.
    void show() {
        SDL_ShowWindow(_window);
    }
    /// Hide Window.
    void hide() {
        SDL_HideWindow(_window);
    }
    /// Minimize window.
    void minimize() {
        SDL_MinimizeWindow(_window);
    }
    /// Maximize window.
    void maximize() {
        SDL_MaximizeWindow(_window);
    }
    /// Get window surface.
    /// Throws $(D PlatformException) on error.
    Surface surface() {
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
    /// Throws $(D PlatformException) on error.
    void updateSurface() {
        if (!_hasValidSurface()) {
	        surface();
        }
        if (SDL_UpdateWindowSurface(_window) != 0) {
	        _platform.throwPlatformException("SDL_UpdateWindowSurface");
        }
    }
    /// Get Window ID.
    int id() {
        return _id;
    }
    /// Get system-specific window information.
    /// Throws $(D PlatformException) on error.
    SDL_SysWMinfo windowInfo() {
        SDL_SysWMinfo info;
        SDL_VERSION(&info.version_);
        if (SDL_GetWindowWMInfo(_window, &info) != SDL_TRUE) {
	        _platform.throwPlatformException("SDL_GetWindowWMInfo");
        }
        return info;
    }
}
///
final class SDL2VideoContext {
	package {
        version (__OpenGL__) {
		    SDL_GLContext _videoContext;
        } else version (__Vulkan__) {
            // TODO.
        }
		SDL2Window _window;
	}
	private {
		bool _initialized;
	}
    /// Creates an OpenGL context for a given SDL window.
    this(SDL2Window window) {
        _window = window;
        version (__OpenGL__) {
            _videoContext = SDL_GL_CreateContext(window._window);
        } else version (__Vulkan__) {
            // TODO.
        }
        _initialized = true;
    }
    ///
    ~this() {
        close();
    }
    /// Releases the SDL ressource.
    void close() {
        if (_initialized) {
            _initialized = false;
        }
    }
    /// Makes this graphics context current.
    /// Throws $(D PlatformException) on error.
    void makeCurrent() {
        version (__OpenGL__) {
            if (0 != SDL_GL_MakeCurrent(_window._window, _videoContext)) {
                _window._platform.throwPlatformException("SDL_GL_MakeCurrent");
            }
        } else version (__Vulkan__) {
            // TODO.
        }
    }
}
///
final class Surface {
    private {
	    Platform _platform;
	    SDL_Surface* _surface;
	    Owned _handleOwned;
    }
    ///
    enum Owned : ubyte {
        ///
        No = 0x00,
        ///
        Yes = 0x01
    }
    ///
    this(Platform platform, SDL_Surface* surface, Owned owned) pure nothrow @trusted @nogc
    in {
        assert (surface !is null, "Surface is null!");
    } do {
        _platform = platform;
        _surface = surface;
        _handleOwned = owned;
    }
    ///
    this(Platform platform, int width, int height, int depth, uint Rmask, uint Gmask, uint Bmask, uint Amask) @trusted {
        _platform = platform;
        _surface = SDL_CreateRGBSurface(0, width, height, depth, Rmask, Gmask, Bmask, Amask);
        if (_surface is null) {
            _platform.throwPlatformException("SDL_CreateRGBSurface");
        }
        _handleOwned = Owned.Yes;
    }
    ///
    this(Platform platform, void* pixels, int width, int height, int depth, int pitch, uint Rmask, uint Gmask, uint Bmask, uint Amask) @trusted {
        _platform = platform;
        _surface = SDL_CreateRGBSurfaceFrom(pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask);
        if (_surface is null) {
            _platform.throwPlatformException("SDL_CreateRGBSurfaceFrom");
        }
        _handleOwned = Owned.Yes;
    }
    ///
    ~this() nothrow @trusted {
        if (_surface !is null) {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("Surface");
            if (_handleOwned == Owned.Yes) {
                SDL_FreeSurface(_surface);
            }
            _surface = null;
        }
    }
    ///
    Surface convert(const(SDL_PixelFormat)* newFormat) @trusted {
        SDL_Surface* surface = SDL_ConvertSurface(_surface, newFormat, 0);
        if (surface is null) {
            _platform.throwPlatformException("SDL_ConvertSurface");
        }
        assert (surface != _surface, "It should not be the same handle!");
        return new Surface(_platform, surface, Owned.Yes);
    }
    ///
    Surface clone() @safe {
        return convert(pixelFormat());
    }
    /// Get surface width.
    int width() pure nothrow const @safe @nogc @property {
        return _surface.w;
    }
    /// Get surface height.
    int height() pure nothrow const @safe @nogc @property {
        return _surface.h;
    }
    /// Get surface pixels.
    ubyte* pixels() pure nothrow const @trusted @nogc @property {
        return cast(ubyte*) _surface.pixels;
    }
    /// Get surface pitch.
    size_t pitch() pure nothrow const @safe @nogc @property {
        return _surface.pitch;
    }
    /// Lock the surface.
    void lock() @trusted {
        if (SDL_LockSurface(_surface) != 0) {
            _platform.throwPlatformException("SDL_LockSurface");
        }
    }
    /// Unlock the surface.
    void unlock() nothrow @trusted @nogc {
        SDL_UnlockSurface(_surface);
    }
    /// Get surface handle.
    SDL_Surface* handle() pure nothrow @safe @nogc {
        return _surface;
    }
    /// Get surface pixel format.
    SDL_PixelFormat* pixelFormat() pure nothrow @safe @nogc {
        return _surface.format;
    }
    ///
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
    ///
    void setColorKey(bool enable, uint key) @trusted {
        if (0 != SDL_SetColorKey(this._surface, enable ? SDL_TRUE : SDL_FALSE, key)) {
            _platform.throwPlatformException("SDL_SetColorKey");
        }
    }
    ///
    void setColorKey(bool enable, ubyte r, ubyte g, ubyte b, ubyte a = 0) @trusted {
        uint key = SDL_MapRGBA(cast(const)this._surface.format, r, g, b, a);
        this.setColorKey(enable, key);
    }
    ///
    void blit(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) @trusted {
        if (0 != SDL_BlitSurface(source._surface, &srcRect, _surface, &dstRect)) {
            _platform.throwPlatformException("SDL_BlitSurface");
        }
    }
    ///
    void blitScaled(Surface source, SDL_Rect srcRect, SDL_Rect dstRect) @trusted {
        if (0 != SDL_BlitScaled(source._surface, &srcRect, _surface, &dstRect)) {
            _platform.throwPlatformException("SDL_BlitScaled");
        }
    }
}
///
class Timer {
    private {
        SDL_TimerID _id;
    }
    /// Create a new timer.
    this(Platform platform, uint intervalMs) @trusted {
        _id = SDL_AddTimer(intervalMs, &timerCallbackSDL, cast(void*)this);
        if (_id == 0) {
            platform.throwPlatformException("SDL_AddTimer");
        }
    }
    /// Get timer id.
    int id() pure nothrow const @safe @nogc @property {
        return _id;
    }
    ~this() nothrow @trusted {
        if (_id != 0) {
            import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("SDL2Timer");
            SDL_RemoveTimer(_id);
            _id = 0;
        }
    }
    ///
    protected abstract uint onTimer(uint interval) nothrow @trusted;
}
extern(C) private uint timerCallbackSDL(uint interval, void* param) nothrow @trusted {
    try {
        Timer timer = cast(Timer)param;
        return timer.onTimer(interval);
    } catch (Exception e) {
        import core.stdc.stdlib : exit;
        exit(-1);
        return 0;
    }
}