/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.input;
import derelict.sdl2.sdl;
import crystal.core.engine;
import derelict.sdl2.sdl;
import crystal.math.vector;
import crystal.core.input;
pragma (inline, true):
///
class Input {
	static:
	private {
		bool[KeyCodeCount] _keyState;
        bool[KeyCodeCount] _oldKeyState;
        const _KEY_PRESSED = true;
        const _KEY_RELEASED = false;
        SDL_Cursor* _cursorHandle;
        int _mouseButtonState;
        int _mouseX = 0;
        int _mouseY = 0;
        int _lastMouseX = 0;
        int _lastMouseY = 0;
        int _mouseWheelX = 0;
        int _mouseWheelY = 0;
        int _mouseDeltaX = 0;
        int _mouseDeltaY = 0;
    }
    package bool _isMouseMoving = false;
    package bool _isMouseWheeling = false;
    package void startService() {
        //useSystemCursor(SystemCursor.Arrow);
        //setCurrentCursor();
    }
    package void releaseService() {
        if (_cursorHandle !is null) {
            SDL_FreeCursor(_cursorHandle);
            _cursorHandle = null;
        }
    }
    void restartServic() {
        releaseService();
        startService();
    }
    ///
    bool isKeyHold(KeyCode key) {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return _keyState[scan] == _KEY_PRESSED;
    }
    ///
    bool isKeyHold(KeyModFlag key) {
        SDL_Keymod mod = SDL_GetModState();
        if (mod & cast(SDL_Keymod)key) {
            //_keyState[mod] = _KEY_PRESSED; // TODO.
            return true;
        }
        return false;
    }
    ///
    bool isKeyDown(KeyCode key) {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return markKeyAsJustReleased(scan);
    }
    ///
    bool isKeyNone(KeyCode key) {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        return _keyState[scan] == _KEY_RELEASED;
    }
    ///
    bool isKeyUp(KeyCode key) {
        SDL_Scancode scan = SDL_GetScancodeFromKey(cast(SDL_Keycode)key);
        bool old_state = (_oldKeyState[scan] == _KEY_PRESSED);
        _oldKeyState[scan] = _KEY_RELEASED;
        return (_keyState[scan] == _KEY_RELEASED) && old_state;
    }
    private void clearKeys() { _keyState[] = _KEY_RELEASED; }
    /*package*/ bool markKeyAsPressed(SDL_Scancode scancode) {
        bool old_state = _keyState[scancode];
        _keyState[scancode] = _KEY_PRESSED;
        return old_state;
    }
    /*package*/ bool markKeyAsJustReleased(SDL_Scancode scancode) {
        bool old_state = _keyState[scancode];
        _keyState[scancode] = _KEY_RELEASED;
        _oldKeyState[scancode] = _KEY_PRESSED;
        return old_state;
    }
    /// Returns current position of the mouse.
    Vector2I getMousePosition() nothrow {
        return Vector2I(_mouseX, _mouseY);
    }
    ///
    Vector2I getLastMousePosition() nothrow {
        return Vector2I(_lastMouseX, _lastMouseY);
    }
    /// Returns previous position of the mouse.
    Vector2I getPreviousMousePosition() nothrow {
        return Vector2I(_mouseX - _mouseDeltaX, _mouseY - _mouseDeltaY);
    }
    /// Returns the relative direction of the mouse.
    Vector2I getMouseRelativeDirection() nothrow {
        return Vector2I(_mouseDeltaX, _mouseDeltaY);
    }
    ///
    Vector2I getMouseDeltaWheel() nothrow {
        Vector2I ret = Vector2I(_mouseWheelX, _mouseWheelY);
        _mouseWheelX = _mouseWheelY = 0;
        return ret;
    }
    ///
    int getMouseDeltaWheelX() nothrow {
        int ret = _mouseWheelX;
        _mouseWheelX = 0;
        return ret;
    }
    ///
    int getMouseDeltaWheelY() nothrow {
        int ret = _mouseWheelY;
        _mouseWheelY = 0;
        return ret;
    }
    ///
    bool isMouseButtonPressed(MouseButton button) nothrow {
        return (_mouseButtonState & SDL_BUTTON(button)) != 0;
    }
    ///
    bool isMouseMoving() nothrow {
        return _isMouseMoving;
    }
    ///
    bool isMouseScrolling() nothrow {
        return _isMouseWheeling;
    }
    //bool isMouseMoving() nothrow {
    //    return getMousePosition() != getLastMousePosition();
    //}
    /// Capture the mouse and track input outside the MainWindow.
    void startMouseCapture() {
        if (SDL_CaptureMouse(SDL_TRUE) != 0) {
            //PlatformManager.throwPlatformException("SDL_CaptureMouse");
            // TODO: Uncomment.
        }
    }
    ///
    void stopMouseCapture() {
        if (SDL_CaptureMouse(SDL_FALSE) != 0) {
            //PlatformManager.throwPlatformException("SDL_CaptureMouse");
            // TODO: Uncomment.
        }
    }
    /*package*/ void updateMouse() {
        _lastMouseX = _mouseX;
        _lastMouseY = _mouseY;
    }
    /*package*/ void updateMouseMotion(const(SDL_MouseMotionEvent)* event) {
        _mouseButtonState = SDL_GetMouseState(null, null);
        _mouseX = event.x;
        _mouseY = event.y;
        _mouseDeltaX = event.xrel;
        _mouseDeltaY = event.yrel;
    }
    /*package*/ void updateMouseButtons(const(SDL_MouseButtonEvent)* event) {
        _mouseButtonState = SDL_GetMouseState(null, null);
        _mouseX = event.x;
        _mouseY = event.y;
    }
    /*package*/ void updateMouseWheel(const(SDL_MouseWheelEvent)* event) {
        _mouseButtonState = SDL_GetMouseState(&_mouseX, &_mouseY);
        _mouseWheelX += event.x;
        _mouseWheelY += event.y;
    }
    ///
    void useSystemCursor(SystemCursor cursor) {
        _cursorHandle = SDL_CreateSystemCursor(cast(SDL_SystemCursor)cursor);
        setCurrentCursor;
    }
    ///
    void createColorCursor(int h_x, int h_y) {
        //_cursorHandle = SDL_CreateColorCursor(SurfaceManager.getHandle(), h_x, h_y);
        // TODO: Uncomment.
        //if (_cursorHandle is null) {
            //PlatformManager.throwPlatformException("SDL_CreateColorCursor");
            // TODO: Uncomment.
        //}
    }
    ///
    void lockMouse(bool lock) {
        //SDL_bool lock_ = cast(SDL_bool)lock;
    	//SDL_ShowCursor(lock_);
    	//SDL_SetWindowGrab(CoreEngine.getMainWindow()._window, lock_);
    	//if ( lock ) {
    	//	mouseLock[0] = mouseInfo.xCur;
    	//	mouseLock[1] = mouseInfo.yCur;
    	//}
    }
    ///
    void setRelativeMouseMode(bool relative = true) {
        SDL_SetRelativeMouseMode(cast(SDL_bool)relative);
    }
    ///
    void setWindowGrab(bool grabbed = true) {
        SDL_SetWindowGrab(CoreEngine.getMainWindow()._window, cast(SDL_bool)grabbed);
    }
    ///
    void setCursorVisible(bool visible = true) {
        SDL_ShowCursor(visible);
    }
    ///
    /*package*/ void setCurrentCursor() {
        SDL_SetCursor(_cursorHandle);
    }
    /*package*/ SDL_Cursor* getCursorHandle() {
        return _cursorHandle;
    }
    /*package*/ SDL_Cursor* getCursor() {
        SDL_Cursor* cursor_handle = SDL_GetCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetCursor");
            // TODO: Uncomment.
        }
        return cursor_handle;
    }
    /*package*/ SDL_Cursor* getDefaultCursor() {
        SDL_Cursor* cursor_handle = SDL_GetDefaultCursor();
        if (cursor_handle is null) {
            //PlatformManager.throwPlatformException("SDL_GetDefaultCursor");
            // TODO: Uncomment.
        }
        return cursor_handle;
    }
}
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