/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/event/wrapper/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.event.wrapper.constants;

import derelict.sdl2.sdl :
  SDL_EventType;

/**
 *
**/
enum EventType : SDL_EventType {
  /**
   *
  **/
  First = SDL_EventType.SDL_FIRSTEVENT,
    
  /**
   *
  **/
  Quit = SDL_EventType.SDL_QUIT,
    
  /**
   *
  **/
  Terminating = SDL_EventType.SDL_APP_TERMINATING,
    
  /**
   *
  **/
  LowMemory = SDL_EventType.SDL_APP_LOWMEMORY,
    
  /**
   *
  **/
  WillEnterBackground = SDL_EventType.SDL_APP_WILLENTERBACKGROUND,
    
  /**
   *
  **/
  DidEnterBackground = SDL_EventType.SDL_APP_DIDENTERBACKGROUND,
    
  /**
   *
  **/
  WillEnterForeground = SDL_EventType.SDL_APP_WILLENTERFOREGROUND,
    
  /**
   *
  **/
  DidEnterForeground = SDL_EventType.SDL_APP_DIDENTERFOREGROUND,
    
  /**
   *
  **/
  Window = SDL_EventType.SDL_WINDOWEVENT,
    
  /**
   *
  **/
  System = SDL_EventType.SDL_SYSWMEVENT,
    
  /**
   *
  **/
  KeyDown = SDL_EventType.SDL_KEYDOWN,
    
  /**
   *
  **/
  KeyUp = SDL_EventType.SDL_KEYUP,
    
  /**
   *
  **/
  TextEditing = SDL_EventType.SDL_TEXTEDITING,
    
  /**
   *
  **/
  TextInput = SDL_EventType.SDL_TEXTINPUT,
    
  /**
   *
  **/
  KeyMapChanged = SDL_EventType.SDL_KEYMAPCHANGED,
    
  /**
   *
  **/
  MouseMotion = SDL_EventType.SDL_MOUSEMOTION,
    
  /**
   *
  **/
  MouseButtonDown = SDL_EventType.SDL_MOUSEBUTTONDOWN,
    
  /**
   *
  **/
  MouseButtonUp = SDL_EventType.SDL_MOUSEBUTTONUP,
    
  /**
   *
  **/
  MouseWheel = SDL_EventType.SDL_MOUSEWHEEL,
    
  /**
   *
  **/
  JoyAxisMotion = SDL_EventType.SDL_JOYAXISMOTION,
    
  /**
   *
  **/
  JoyBallMotion = SDL_EventType.SDL_JOYBALLMOTION,
    
  /**
   *
  **/
  JoyHatMotion = SDL_EventType.SDL_JOYHATMOTION,
    
  /**
   *
  **/
  JoyButtonDown = SDL_EventType.SDL_JOYBUTTONDOWN,
    
  /**
   *
  **/
  JoyButtonUp = SDL_EventType.SDL_JOYBUTTONUP,
    
  /**
   *
  **/
  JoyDeviceAdded = SDL_EventType.SDL_JOYDEVICEADDED,
    
  /**
   *
  **/
  JoyDeviceRemoved = SDL_EventType.SDL_JOYDEVICEREMOVED,
    
  /**
   *
  **/
  ControllerAxisMotion = SDL_EventType.SDL_CONTROLLERAXISMOTION,
    
  /**
   *
  **/
  ControllerButtonDown = SDL_EventType.SDL_CONTROLLERBUTTONDOWN,
    
  /**
   *
  **/
  ControllerButtonUp = SDL_EventType.SDL_CONTROLLERBUTTONUP,
    
  /**
   *
  **/
  ControllerDeviceAdded = SDL_EventType.SDL_CONTROLLERDEVICEADDED,
    
  /**
   *
  **/
  ControllerDeviceRemoved = SDL_EventType.SDL_CONTROLLERDEVICEREMOVED,
    
  /**
   *
  **/
  ControllerDeviceRemapped = SDL_EventType.SDL_CONTROLLERDEVICEREMAPPED,
    
  /**
   *
  **/
  FingerDown = SDL_EventType.SDL_FINGERDOWN,
    
  /**
   *
  **/
  FingerUp = SDL_EventType.SDL_FINGERUP,
    
  /**
   *
  **/
  FingerMotion = SDL_EventType.SDL_FINGERMOTION,
    
  /**
   *
  **/
  DollarGesture = SDL_EventType.SDL_DOLLARGESTURE,
    
  /**
   *
  **/
  DollarRecord = SDL_EventType.SDL_DOLLARRECORD,
    
  /**
   *
  **/
  MultiGesture = SDL_EventType.SDL_MULTIGESTURE,
    
  /**
   *
  **/
  ClipboardUpdate = SDL_EventType.SDL_CLIPBOARDUPDATE,
    
  /**
   *
  **/
  DropFile = SDL_EventType.SDL_DROPFILE,
    
  /**
   *
  **/
  DropText = SDL_EventType.SDL_DROPTEXT,
    
  /**
   *
  **/
  DropBegin = SDL_EventType.SDL_DROPBEGIN,
    
  /**
   *
  **/
  DropComplete = SDL_EventType.SDL_DROPCOMPLETE,
    
  /**
   *
  **/
  AudioDeviceAdded = SDL_EventType.SDL_AUDIODEVICEADDED,
    
  /**
   *
  **/
  AudioDeviceRemoved = SDL_EventType.SDL_AUDIODEVICEREMOVED,
    
  /**
   *
  **/
  RenderTargetsReset = SDL_EventType.SDL_RENDER_TARGETS_RESET,
    
  /**
   *
  **/
  RenderDeviceReset = SDL_EventType.SDL_RENDER_DEVICE_RESET,
    
  /**
   *
  **/
  User = SDL_EventType.SDL_USEREVENT,
    
  /**
   *
  **/
  Last = SDL_EventType.SDL_LASTEVENT
}