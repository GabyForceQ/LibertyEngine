/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window.constants;

import derelict.sdl2.sdl :
  SDL_WINDOWPOS_UNDEFINED,
  SDL_WINDOWPOS_CENTERED,
  SDL_WindowFlags,
  SDL_WindowEventID;

/**
 *
**/
enum WindowPosition : int {
  /**
   *
  **/
  Undefined = SDL_WINDOWPOS_UNDEFINED,

  /**
   *
  **/
  Centered = SDL_WINDOWPOS_CENTERED
}

/**
 *
**/
enum WindowFlags : int {
  /**
   *
  **/
  Fullscreen = SDL_WindowFlags.SDL_WINDOW_FULLSCREEN,

  /**
   *
  **/
  OpenGL = SDL_WindowFlags.SDL_WINDOW_OPENGL,

  /**
   *
  **/
  Shown = SDL_WindowFlags.SDL_WINDOW_SHOWN,
  
  /**
   *
  **/
  Hidden = SDL_WindowFlags.SDL_WINDOW_HIDDEN,
    
  /**
   *
  **/
  Borderless = SDL_WindowFlags.SDL_WINDOW_BORDERLESS,
    
  /**
   *
  **/
  Resizable = SDL_WindowFlags.SDL_WINDOW_RESIZABLE,
    
  /**
   *
  **/
  Minimized = SDL_WindowFlags.SDL_WINDOW_MINIMIZED,
    
  /**
   *
  **/
  Maximized = SDL_WindowFlags.SDL_WINDOW_MAXIMIZED,
    
  /**
   *
  **/
  InputGrabbed = SDL_WindowFlags.SDL_WINDOW_INPUT_GRABBED,
    
  /**
   *
  **/
  InputFocus = SDL_WindowFlags.SDL_WINDOW_INPUT_FOCUS,
    
  /**
   *
  **/
  MouseFocus = SDL_WindowFlags.SDL_WINDOW_MOUSE_FOCUS,
    
  /**
   *
  **/
  FullscreenDesktop = SDL_WindowFlags.SDL_WINDOW_FULLSCREEN_DESKTOP,
    
  /**
   *
  **/
  Foreign = SDL_WindowFlags.SDL_WINDOW_FOREIGN,
    
  /**
   *
  **/
  AllowHighDPI = SDL_WindowFlags.SDL_WINDOW_ALLOW_HIGHDPI,
    
  /**
   *
  **/
  MouseCapture = SDL_WindowFlags.SDL_WINDOW_MOUSE_CAPTURE,
    
  /**
   *
  **/
  AlwaysOnTop = SDL_WindowFlags.SDL_WINDOW_ALWAYS_ON_TOP,
    
  /**
   *
  **/
  SkipTaskbar = SDL_WindowFlags.SDL_WINDOW_SKIP_TASKBAR,
    
  /**
   *
  **/
  Utility = SDL_WindowFlags.SDL_WINDOW_UTILITY,
    
  /**
   *
  **/
  ToolTip = SDL_WindowFlags.SDL_WINDOW_TOOLTIP,
    
  /**
   *
  **/
  PopupMenu = SDL_WindowFlags.SDL_WINDOW_POPUP_MENU,

    
  /**
   *
  **/
  Vulkan = SDL_WindowFlags.SDL_WINDOW_VULKAN
}

/**
 *
**/
enum WindowEvent : ubyte {
  /**
   *
  **/
  None = SDL_WindowEventID.SDL_WINDOWEVENT_NONE,

  /**
   *
  **/
  Shown = SDL_WindowEventID.SDL_WINDOWEVENT_SHOWN,

  /**
   *
  **/
  Hidden = SDL_WindowEventID.SDL_WINDOWEVENT_HIDDEN,

  /**
   *
  **/
  Exposed = SDL_WindowEventID.SDL_WINDOWEVENT_EXPOSED,

  /**
   *
  **/
  Moved = SDL_WindowEventID.SDL_WINDOWEVENT_MOVED,

  /**
   *
  **/
  Resized = SDL_WindowEventID.SDL_WINDOWEVENT_RESIZED,

  /**
   *
  **/
  SizeChanged = SDL_WindowEventID.SDL_WINDOWEVENT_SIZE_CHANGED,

  /**
   *
  **/
  Minimized = SDL_WindowEventID.SDL_WINDOWEVENT_MINIMIZED,

  /**
   *
  **/
  Maximized = SDL_WindowEventID.SDL_WINDOWEVENT_MAXIMIZED,

  /**
   *
  **/
  Restored = SDL_WindowEventID.SDL_WINDOWEVENT_RESTORED,

  /**
   *
  **/
  Enter = SDL_WindowEventID.SDL_WINDOWEVENT_ENTER,

  /**
   *
  **/
  Leave = SDL_WindowEventID.SDL_WINDOWEVENT_LEAVE,

  /**
   *
  **/
  FocusGained = SDL_WindowEventID.SDL_WINDOWEVENT_FOCUS_GAINED,

  /**
   *
  **/
  FocusLost = SDL_WindowEventID.SDL_WINDOWEVENT_FOCUS_LOST,

  /**
   *
  **/
  Close = SDL_WindowEventID.SDL_WINDOWEVENT_CLOSE,

  /**
   *
  **/
  TakeFocus = SDL_WindowEventID.SDL_WINDOWEVENT_TAKE_FOCUS,

  /**
   *
  **/
  HitTest = SDL_WindowEventID.SDL_WINDOWEVENT_HIT_TEST
}