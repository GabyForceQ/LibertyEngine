/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.input.constants;

import derelict.glfw3.glfw3;

/**
 *
**/
enum byte MOUSE_BUTTONS = 3;

/**
 *
**/
enum short KEY_CODES = 512;

/**
 *
**/
enum MouseButton : byte {
  LEFT = GLFW_MOUSE_BUTTON_1,
  RIGHT = GLFW_MOUSE_BUTTON_2,
  MIDDLE = GLFW_MOUSE_BUTTON_3
}

/**
 *
**/
enum KeyCode : short {
  SPACE = GLFW_KEY_SPACE,
  A = GLFW_KEY_A,
  B = GLFW_KEY_B,
  C = GLFW_KEY_C,
  D = GLFW_KEY_D,
  E = GLFW_KEY_E,
  F = GLFW_KEY_F,
  G = GLFW_KEY_G,
  H = GLFW_KEY_H,
  I = GLFW_KEY_I,
  J = GLFW_KEY_J,
  K = GLFW_KEY_K,
  L = GLFW_KEY_L,
  M = GLFW_KEY_M,
  N = GLFW_KEY_N,
  O = GLFW_KEY_O,
  P = GLFW_KEY_P,
  Q = GLFW_KEY_Q,
  R = GLFW_KEY_R,
  S = GLFW_KEY_S,
  T = GLFW_KEY_T,
  U = GLFW_KEY_U,
  V = GLFW_KEY_V,
  W = GLFW_KEY_W,
  X = GLFW_KEY_X,
  Y = GLFW_KEY_Y,
  Z = GLFW_KEY_Z,
  ESC = GLFW_KEY_ESCAPE,
  ENTER = GLFW_KEY_ENTER,
  RIGHT = GLFW_KEY_RIGHT,
  LEFT = GLFW_KEY_LEFT,
  DOWN = GLFW_KEY_DOWN,
  UP = GLFW_KEY_UP
}