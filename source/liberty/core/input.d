/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input.d, _input.d)
 * Documentation:
 * Coverage:
 */
 // TODO: Add controller.
module liberty.core.input;
import derelict.sdl2.sdl;
import liberty.math.vector : Vector2I, Vector2F;
import liberty.core.utils : Singleton, IService;
import liberty.core.world.services : IUpdatable;
import liberty.core.logger : Logger;
import liberty.core.engine : mainWindow;
pragma (inline, true):
///
final class InputNova : Singleton!InputNova, IService, IUpdatable {
    private {
        SDL_Cursor* _cursorHandle;
        SystemCursor _systemCursor;
        Vector2I _mousePosition;
        bool[] _keyState;
        bool[] _oldKeyState;
        bool[] _btnState;
        bool[] _oldBtnState;
        bool _serviceRunning;
    }
    /// Start Input service.
    void startService() @trusted {
        _serviceRunning = true;
        Logger.get.info("Input service started.");
        systemCursor = SystemCursor.Arrow;
        update(0.0f);
        _oldKeyState = _keyState;
        _oldBtnState = _btnState;
    }
    /// Stop Input service.
    void stopService() @trusted {
        if (_cursorHandle !is null) {
            SDL_FreeCursor(_cursorHandle);
            _cursorHandle = null;
        }
        _serviceRunning = false;
        Logger.get.info("Input service stopped.");
    }
    /// Restart Input service.
    void restartService() @trusted {
        stopService();
        startService();
    }
    /// Returns true if Input service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
    ///
    void update(in float deltaTime) {
        updateKeyState();
        int x, y;
        immutable uint mouseState = updateMouseState(x, y);
        updateBtnState(mouseState);
        updateMousePosition(x, y);
    }
    /// Returns true if the key is pressed and was not pressed in the last tick
    bool isKeyDown(Key key) {
        return !_oldKeyState[cast(int)key] && _keyState[cast(int)key];
    }
    ///
    bool isKeyHold(Key key) {
        return _keyState[cast(int)key];
    }
    ///
    bool isKeyUp(Key key) {
        return !_keyState[cast(int)key];
    }
    ///
    bool isMouseButtonDown(MouseButton button) {
        return _oldBtnState[button] && !_btnState[button];
    }
    ///
    bool isMouseButtonHold(MouseButton button) {
        return _btnState[button];
    }
    ///
    bool isMouseButtonUp(MouseButton button) {
        return !_btnState[button];
    }
    ///
    Vector2I mousePosition() {
        return _mousePosition;
    }
    ///
    Vector2F stick(Key up, Key right, Key down, Key left) {
        return Vector2F(isKeyHold(right) - isKeyHold(left), isKeyHold(up) - isKeyHold(down)).normalized();
    }
    /// Sets the current cursor type using a specific system cursor.
    void systemCursor(SystemCursor cursor) nothrow @trusted @property {
        _cursorHandle = SDL_CreateSystemCursor(cast(SDL_SystemCursor)cursor);
        setCurrentCursor();
        _systemCursor = cursor;
    }
    /// Gets the current system cursor type.
    SystemCursor systemCursor() pure nothrow const @safe @nogc @property {
        return _systemCursor;
    }
    ///
    void cursorVisible(bool visible = true) nothrow @trusted @nogc {
        SDL_ShowCursor(visible);
    }
    ///
    void setCurrentCursor() nothrow @trusted @nogc {
        SDL_SetCursor(_cursorHandle);
    }
    SDL_Cursor* cursorHandle() pure nothrow @safe @nogc {
        return _cursorHandle;
    }
    SDL_Cursor* cursor() nothrow @trusted @nogc {
        SDL_Cursor* cursor_handle = SDL_GetCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetCursor");
            //TODO: Uncomment.
        }
        return cursor_handle;
    }
    SDL_Cursor* defaultCursor() nothrow @trusted @nogc {
        SDL_Cursor* cursor_handle = SDL_GetDefaultCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetDefaultCursor");
            //TODO: Uncomment.
        }
        return cursor_handle;
    }
    private void updateKeyState() {
        int ksLen;
        const(ubyte*) sdlKs = SDL_GetKeyboardState(&ksLen);
        _oldKeyState = _keyState;
        _keyState = [];
        _keyState.length = ksLen;
        (cast(ubyte*)_keyState)[0 .. ksLen][] = sdlKs[0 .. ksLen];
    }
    private uint updateMouseState(out int x, out int y) {
        return SDL_GetMouseState(&x, &y);
    }
    private void updateBtnState(uint mouseState) {
        _btnState = [];
        _btnState.length = 5;
        foreach (i; 0..MouseButton.max) { // TODO?
            ubyte btn = SDL_BUTTON(cast(ubyte)(i + 1));
            _btnState[i] = cast(bool)(mouseState & btn);
        }
    }
    private void updateMousePosition(int x, int y) {
        _mousePosition.x = cast(int)(-1 + x / (mainWindow.width * 0.5f));
        _mousePosition.y = cast(int)(1 - y / (mainWindow.height * 0.5f));
    }
}

///
deprecated("Input Service is deprecated. Use InputNova instead.")
final class Input : Singleton!Input, IService {
	private {
        bool _serviceRunning;
		bool[KeyCodeCount] _keyState;
        bool[KeyCodeCount] _oldKeyState;
        const _KEY_PRESSED = true;
        const _KEY_RELEASED = false;
        SDL_Cursor* _cursorHandle;
        int _mouseButtonState;
        int _mouseX;
        int _mouseY;
        int _lastMouseX;
        int _lastMouseY;
        int _mouseWheelX;
        int _mouseWheelY;
        int _mouseDeltaX;
        int _mouseDeltaY;
        SystemCursor _systemCursor;
    }
    package {
        bool _isMouseMoving;
        bool _isMouseWheeling;
    } 
    /// Start Input service.
    void startService() @trusted {
        systemCursor = SystemCursor.Arrow;
        _serviceRunning = true;
        Logger.get.info("Input service started.");
    }
    /// Stop Input service.
    void stopService() @trusted {
        if (_cursorHandle !is null) {
            SDL_FreeCursor(_cursorHandle);
            _cursorHandle = null;
        }
        _serviceRunning = false;
        Logger.get.info("Input service stopped.");
    }
    /// Restart Input service.
    void restartService() @trusted {
        stopService();
        startService();
    }
    /// Returns true if Input service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
    /// Returns true if key is still pressed in an event loop.
    bool isKeyHold(KeyCode key) nothrow @trusted @nogc {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return _keyState[scan] == _KEY_PRESSED;
    }
    /// Returns true if key mod is still pressed in an event loop.
    bool isKeyHold(KeyModFlag key) nothrow @trusted @nogc {
        immutable SDL_Keymod mod = SDL_GetModState();
        if (mod & cast(SDL_Keymod)key) {
            //_keyState[mod] = _KEY_PRESSED; // TODO.
            return true;
        }
        return false;
    }
    /// Returns true if key is just pressed in an event loop.
    bool isKeyDown(KeyCode key) nothrow @trusted @nogc {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return markKeyAsJustReleased(scan);
    }
    /// Returns true if key has no input action in an event loop.
    bool isKeyNone(KeyCode key) nothrow @trusted @nogc {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return _keyState[scan] == _KEY_RELEASED;
    }
    /// Returns true if key is just released in an event loop.
    bool isKeyUp(KeyCode key) nothrow @trusted @nogc {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        bool old_state = (_oldKeyState[scan] == _KEY_PRESSED);
        _oldKeyState[scan] = _KEY_RELEASED;
        return (_keyState[scan] == _KEY_RELEASED) && old_state;
    }
    private void clearKeys() pure nothrow @safe @nogc { 
        _keyState[] = _KEY_RELEASED; 
    }
    /*package*/ bool markKeyAsPressed(SDL_Scancode scancode) pure nothrow @safe @nogc {
        bool old_state = _keyState[scancode];
        _keyState[scancode] = _KEY_PRESSED;
        return old_state;
    }
    /*package*/ bool markKeyAsJustReleased(SDL_Scancode scancode) pure nothrow @safe @nogc {
        bool old_state = _keyState[scancode];
        _keyState[scancode] = _KEY_RELEASED;
        _oldKeyState[scancode] = _KEY_PRESSED;
        return old_state;
    }
    /// Returns current position of the mouse.
    Vector2I mousePosition() pure nothrow @safe @nogc {
        return Vector2I(_mouseX, _mouseY);
    }
    /// Returns last position of the mouse.
    Vector2I lastMousePosition() pure nothrow @safe @nogc {
        return Vector2I(_lastMouseX, _lastMouseY);
    }
    /// Returns previous position of the mouse.
    Vector2I previousMousePosition() pure nothrow @safe @nogc {
        return Vector2I(_mouseX - _mouseDeltaX, _mouseY - _mouseDeltaY);
    }
    /// Returns the relative direction of the mouse.
    Vector2I mouseRelativeDirection() pure nothrow @safe @nogc {
        return Vector2I(_mouseDeltaX, _mouseDeltaY);
    }
    ///
    Vector2I mouseDeltaWheel() pure nothrow @safe @nogc {
        Vector2I ret = Vector2I(_mouseWheelX, _mouseWheelY);
        _mouseWheelX = _mouseWheelY = 0;
        return ret;
    }
    ///
    int mouseDeltaWheelX() pure nothrow @safe @nogc {
        int ret = _mouseWheelX;
        _mouseWheelX = 0;
        return ret;
    }
    ///
    int mouseDeltaWheelY() pure nothrow @safe @nogc {
        int ret = _mouseWheelY;
        _mouseWheelY = 0;
        return ret;
    }
    ///
    bool isMouseButtonPressed(MouseButton button) pure nothrow const @trusted @nogc {
        return (_mouseButtonState & SDL_BUTTON(button)) != 0;
    }
    /// Returns true if mouse is moving.
    bool isMouseMoving() pure nothrow const @safe @nogc {
        return _isMouseMoving;
    }
    /// Returns true if mouse is scrolling.
    bool isMouseScrolling() pure nothrow const @safe @nogc {
        return _isMouseWheeling;
    }
    //bool isMouseMoving() nothrow {
    //    return mousePosition() != lastMousePosition();
    //}
    /// Capture the mouse and track input outside the MainWindow.
    void startMouseCapture() nothrow @trusted @nogc {
        if (SDL_CaptureMouse(SDL_TRUE) != 0) {
            //PlatformManager.throwPlatformException("SDL_CaptureMouse");
            // TODO: Uncomment.
        }
    }
    ///
    void stopMouseCapture() nothrow @trusted @nogc {
        if (SDL_CaptureMouse(SDL_FALSE) != 0) {
            //PlatformManager.throwPlatformException("SDL_CaptureMouse");
            // TODO: Uncomment.
        }
    }
    /*package*/ void updateMouse() pure nothrow @safe @nogc {
        _lastMouseX = _mouseX;
        _lastMouseY = _mouseY;
    }
    /*package*/ void updateMouseMotion(const(SDL_MouseMotionEvent)* event) nothrow @trusted @nogc {
        _mouseButtonState = SDL_GetMouseState(null, null);
        _mouseX = event.x;
        _mouseY = event.y;
        _mouseDeltaX = event.xrel;
        _mouseDeltaY = event.yrel;
    }
    /*package*/ void updateMouseButtons(const(SDL_MouseButtonEvent)* event) nothrow @trusted @nogc {
        _mouseButtonState = SDL_GetMouseState(null, null);
        _mouseX = event.x;
        _mouseY = event.y;
    }
    /*package*/ void updateMouseWheel(const(SDL_MouseWheelEvent)* event) nothrow @trusted @nogc {
        _mouseButtonState = SDL_GetMouseState(&_mouseX, &_mouseY);
        _mouseWheelX += event.x;
        _mouseWheelY += event.y;
    }
    /// Sets the current cursor type using a specific system cursor.
    void systemCursor(SystemCursor cursor) nothrow @trusted @property {
        _cursorHandle = SDL_CreateSystemCursor(cast(SDL_SystemCursor)cursor);
        setCurrentCursor();
        _systemCursor = cursor;
    }
    /// Gets the current system cursor type.
    SystemCursor systemCursor() pure nothrow const @safe @nogc @property {
        return _systemCursor;
    }
    ///
    void createColorCursor(int h_x, int h_y) nothrow @trusted @nogc {
        //_cursorHandle = SDL_CreateColorCursor(SurfaceManager.getHandle(), h_x, h_y);
        // TODO: Uncomment.
        //if (_cursorHandle is null) {
            //PlatformManager.throwPlatformException("SDL_CreateColorCursor");
            // TODO: Uncomment.
        //}
    }
    ///
    void lockMouse(bool lock) nothrow @trusted @nogc {
        //import liberty.core.engine : CoreEngine;
        //SDL_bool lock_ = cast(SDL_bool)lock;
    	//SDL_ShowCursor(lock_);
    	//SDL_SetWindowGrab(CoreEngine.get.mainWindow._window, lock_);
    	//if ( lock ) {
    	//	mouseLock[0] = mouseInfo.xCur;
    	//	mouseLock[1] = mouseInfo.yCur;
    	//}
    }
    ///
    void relativeMouseMode(bool relative = true) nothrow @trusted @nogc {
        SDL_SetRelativeMouseMode(cast(SDL_bool)relative);
    }
    ///
    void windowGrab(bool grabbed = true) @trusted {
        import liberty.core.engine : CoreEngine;
        SDL_SetWindowGrab(CoreEngine.get.mainWindow._window, cast(SDL_bool)grabbed);
    }
    ///
    void cursorVisible(bool visible = true) nothrow @trusted @nogc {
        SDL_ShowCursor(visible);
    }
    ///
    /*package*/ void setCurrentCursor() nothrow @trusted @nogc {
        SDL_SetCursor(_cursorHandle);
    }
    /*package*/ SDL_Cursor* cursorHandle() pure nothrow @safe @nogc {
        return _cursorHandle;
    }
    /*package*/ SDL_Cursor* cursor() nothrow @trusted @nogc {
        SDL_Cursor* cursor_handle = SDL_GetCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetCursor");
            // TODO: Uncomment.
        }
        return cursor_handle;
    }
    /*package*/ SDL_Cursor* defaultCursor() nothrow @trusted @nogc {
        SDL_Cursor* cursor_handle = SDL_GetDefaultCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetDefaultCursor");
            // TODO: Uncomment.
        }
        return cursor_handle;
    }
}
///
alias Key = KeyCode;
/// Number of keycodes.
enum KeyCodeCount = 512;
///
enum KeyCode : int {
	/// Unknown keycode has value equals to 0.
	Unknown = SDLK_UNKNOWN,
	/// Return keycode has value equals to '\r' (carriage return).
	Return = SDLK_RETURN,
    /// Esc keycode has value equals to '\033'.
    Esc = SDLK_ESCAPE,
    /// Backspace keyword has value equals to '\b'.
    Backspace = SDLK_BACKSPACE,
    /// Tab keyword has value equals to '\t'.
    Tab = SDLK_TAB,
    /// Space keyword has value equals to ' '.
    Space = SDLK_SPACE,
    /// Exclamation keyword has value equals to '!'.
    Exclamation = SDLK_EXCLAIM,
    ///
    DoubleQuote = SDLK_QUOTEDBL,
    ///
    Sharp = SDLK_HASH,
    ///
    Percent = SDLK_PERCENT,
    ///
    Dollar = SDLK_DOLLAR,
    ///
    Ampersand = SDLK_AMPERSAND,
    ///
    SingleQuote = SDLK_QUOTE,
    ///
    LeftParenthesis = SDLK_LEFTPAREN,
    ///
    RightParenthesis = SDLK_RIGHTPAREN,
    ///
    Star = SDLK_ASTERISK,
    ///
    Plus = SDLK_PLUS,
    ///
    Comma = SDLK_COMMA,
    ///
    Minus = SDLK_MINUS,
    ///
    Dot = SDLK_PERIOD,
    ///
    Slash = SDLK_SLASH,
    ///
    Key0 = SDLK_0,
    ///
    Key1 = SDLK_1,
    ///
    Key2 = SDLK_2,
    ///
    Key3 = SDLK_3,
    ///
    Key4 = SDLK_4,
    ///
    Key5 = SDLK_5,
    ///
    Key6 = SDLK_6,
    ///
    Key7 = SDLK_7,
    ///
    Key8 = SDLK_8,
    ///
    Key9 = SDLK_9,
    ///
    Colon = SDLK_COLON,
    ///
    Semicolon = SDLK_SEMICOLON,
    ///
    Less = SDLK_LESS,
    ///
    Equals = SDLK_EQUALS,
    ///
    Greater = SDLK_GREATER,
    ///
    Question = SDLK_QUESTION,
    ///
    MonkeyTail = SDLK_AT,
    ///
    LeftBracket = SDLK_LEFTBRACKET,
    ///
    Backslash = SDLK_BACKSLASH,
    ///
    RightBracket = SDLK_RIGHTBRACKET,
    ///
    Caret = SDLK_CARET,
    ///
    Underscore = SDLK_UNDERSCORE,
    ///
    Backquote = SDLK_BACKQUOTE,
    ///
    A = SDLK_a,
    ///
    B = SDLK_b,
    ///
    C = SDLK_c,
    ///
    D = SDLK_d,
    ///
    E = SDLK_e,
    ///
    F = SDLK_f,
    ///
    G = SDLK_g,
    ///
    H = SDLK_h,
    ///
    I = SDLK_i,
    ///
    J = SDLK_j,
    ///
    K = SDLK_k,
    ///
    L = SDLK_l,
    ///
    M = SDLK_m,
    ///
    N = SDLK_n,
    ///
    O = SDLK_o,
    ///
    P = SDLK_p,
    ///
    Q = SDLK_q,
    ///
    R = SDLK_r,
    ///
    S = SDLK_s,
    ///
    T = SDLK_t,
    ///
    U = SDLK_u,
    ///
    V = SDLK_v,
    ///
    W = SDLK_w,
    ///
    X = SDLK_x,
    ///
    Y = SDLK_y,
    ///
    Z = SDLK_z,
    ///
    CapsLock = SDLK_CAPSLOCK,
    ///
    F1 = SDLK_F1,
    ///
    F2 = SDLK_F2,
    ///
    F3 = SDLK_F3,
    ///
    F4 = SDLK_F4,
    ///
    F5 = SDLK_F5,
    ///
    F6 = SDLK_F6,
    ///
    F7 = SDLK_F7,
    ///
    F8 = SDLK_F8,
    ///
    F9 = SDLK_F9,
    ///
    F10 = SDLK_F10,
    ///
    F11 = SDLK_F11,
    ///
    F12 = SDLK_F12,
    ///
    Printsceen = SDLK_PRINTSCREEN,
    ///
    ScrollLock = SDLK_SCROLLLOCK,
    ///
    Pause = SDLK_PAUSE,
    ///
    Insert = SDLK_INSERT,
    ///
    Home = SDLK_HOME,
    ///
    PageUp = SDLK_PAGEUP,
    ///
    Delete = SDLK_DELETE,
    ///
    End = SDLK_END,
    ///
    PageDown = SDLK_PAGEDOWN,
    ///
    Right = SDLK_RIGHT,
    ///
    Left = SDLK_LEFT,
    ///
    Down = SDLK_DOWN,
    ///
    Up = SDLK_UP,
    ///
    NumLockClear = SDLK_NUMLOCKCLEAR,
    ///
    Divide = SDLK_KP_DIVIDE,
    ///
    Multiply = SDLK_KP_MULTIPLY,
    ///
    Subtract = SDLK_KP_MINUS,
    ///
    Add = SDLK_KP_PLUS,
    ///
    Enter = SDLK_KP_ENTER,
    ///
    Num1 = SDLK_KP_1,
    ///
    Num2 = SDLK_KP_2,
    ///
    Num3 = SDLK_KP_3,
    ///
    Num4 = SDLK_KP_4,
    ///
    Num5 = SDLK_KP_5,
    ///
    Num6 = SDLK_KP_6,
    ///
    Num7 = SDLK_KP_7,
    ///
    Num8 = SDLK_KP_8,
    ///
    Num9 = SDLK_KP_9,
    ///
    Num0 = SDLK_KP_0,
    ///
    Period = SDLK_KP_PERIOD
    // TODO: Finish.
}
///
enum KeyModFlag : int { // TODO: Change name?
	///
	None = KMOD_NONE,
	///
	LeftShift = KMOD_LSHIFT,
	///
	RightShift = KMOD_RSHIFT,
	///
	LeftCtrl = KMOD_LCTRL,
	///
	RightCtrl = KMOD_RCTRL,
	///
	LeftAlt = KMOD_LALT,
	///
	RightAlt = KMOD_RALT,
	///
	LeftGUI = KMOD_LGUI,
	///
	RightGUI = KMOD_RGUI,
	///
	Num = KMOD_NUM,
	///
	Caps = KMOD_CAPS,
	///
	Mode = KMOD_MODE,
	///
	Reserved = KMOD_RESERVED,
	///
	Ctrl = KMOD_CTRL,
	///
	Shift = KMOD_SHIFT,
	///
	Alt = KMOD_ALT,
	///
	Gui = KMOD_GUI,
}
///
enum MouseButton : ubyte {
	///
	Left = SDL_BUTTON_LEFT,
	///
	Middle = SDL_BUTTON_MIDDLE,
	///
	Right = SDL_BUTTON_RIGHT,
	///
	X1 = SDL_BUTTON_X1,
	///
	X2 = SDL_BUTTON_X2,
	///
	LeftMask = SDL_BUTTON_LMASK,
	///
	MiddleMask = SDL_BUTTON_MMASK,
	///
	RightMask = SDL_BUTTON_RMASK,
	///
	X1Mask = SDL_BUTTON_X1MASK,
	///
	X2Mask = SDL_BUTTON_X2MASK
}
/// All types of supported cursor found in system.
enum SystemCursor : int {
	/// Arrow cursor.
	Arrow = SDL_SYSTEM_CURSOR_ARROW,
	/// I-Beam cursor.
	IBeam = SDL_SYSTEM_CURSOR_IBEAM,
	/// Wait cursor.
	Wait = SDL_SYSTEM_CURSOR_WAIT,
	/// Crosshair cursor.
	CrossHair = SDL_SYSTEM_CURSOR_CROSSHAIR,
	/// Small wait cursor.
	WaitArrow = SDL_SYSTEM_CURSOR_WAITARROW,
	/// Double arrow pointing northwest and southeast cursor.
	SizeNWSE = SDL_SYSTEM_CURSOR_SIZENWSE,
	/// Double arrow pointing northeast and southwest cursor.
	SizeNESW = SDL_SYSTEM_CURSOR_SIZENESW,
	/// Double arrow pointing west and east cursor.
	SizeWE = SDL_SYSTEM_CURSOR_SIZEWE,
	/// Double arrow pointing north and south cursor.
	SizeNS = SDL_SYSTEM_CURSOR_SIZENS,
	/// Four pointed arrow pointing north, south, east and west cursor.
	SizeAll = SDL_SYSTEM_CURSOR_SIZEALL,
	/// Slashed circle cursor.
	No = SDL_SYSTEM_CURSOR_NO,
	/// Hand cursor.
	Hand = SDL_SYSTEM_CURSOR_HAND
}