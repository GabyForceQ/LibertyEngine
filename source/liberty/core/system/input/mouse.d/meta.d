module liberty.core.system.input.mouse.meta;

/**
 *
 */
immutable MouseBody = q{
    
    private {
        import liberty.core.system.input.mouse.constants : MouseButton;
        import liberty.core.math.vector : Vector2I;
        import derelict.sdl2.sdl : SDL_GetMouseState, SDL_BUTTON;

        Vector2I _mousePosition;
        bool[] _btnState;
        bool[] _oldBtnState;
    }

    /**
    *
    */
    bool isMouseButtonDown(MouseButton button) {
        return _oldBtnState[button] && !_btnState[button];
    }

    /**
    *
    */
    bool isMouseButtonHold(MouseButton button) {
        return _btnState[button];
    }
    
    /**
    *
    */
    bool isMouseButtonUp(MouseButton button) {
        return !_btnState[button];
    }
    
    /**
    *
    */
    Vector2I mousePosition() {
        return _mousePosition;
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
    
    package(liberty.core.system) void updateMousePosition(int x, int y) {
        _mousePosition.x = x;
        _mousePosition.y = y;
    }

};