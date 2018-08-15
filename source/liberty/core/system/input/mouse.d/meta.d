/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/mouse/meta.d, _meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.input.mouse.meta;

/**
 *
**/
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
  **/
  bool isMouseButtonDown(MouseButton button) {
    return _oldBtnState[button] && !_btnState[button];
  }

  /**
   *
  **/
  bool isMouseButtonHold(MouseButton button) {
    return _btnState[button];
  }
  
  /**
   *
  **/
  bool isMouseButtonUp(MouseButton button) {
    return !_btnState[button];
  }
  
  /**
   *
  **/
  Vector2I mousePosition() {
    return _mousePosition;
  }

  package(liberty.core.system) void updateMousePosition(int x, int y) {
    _mousePosition.x = x;
    _mousePosition.y = y;
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
};