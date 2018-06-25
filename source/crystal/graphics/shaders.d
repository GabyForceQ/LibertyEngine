/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// todo: get rid of this module
// todo: use OpenGL 4.5 / OpenGLES 3.0 / Vulkan 1.1
module crystal.graphics.shaders;
/**** TERRAIN VERTEX SHADER + FRAGMENT SHADER ****/
///
immutable terrainVS_GL = import("shaders/terrainVS_GL.glsl");
///
immutable terrainVS_GLES = q{};
///
immutable terrainVS_VK = q{};
///
immutable terrainFS_GL = import("shaders/terrainFS_GL.glsl");
///
immutable terrainFS_GLES = q{};
///
immutable terrainFS_VK = q{};
/**** UI VERTEX SHADER + FRAGMENT SHADER ****/
///
immutable uiVS_GL = import("shaders/uiVS_GL.glsl");
///
immutable uiVS_GLES = q{};
///
immutable uiVS_VK = q{};
///
immutable uiFS_GL = import("shaders/uiFS_GL.glsl");
///
immutable uiFS_GLES = q{};
///
immutable uiFS_VK = q{};