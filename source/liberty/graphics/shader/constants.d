/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.constants;

/**
 *
**/
enum ShaderType : ubyte {
  /**
   *
  **/
  Vertex = 0x00,

  /**
   *
  **/
  Fragment = 0x01
}

/**
 *
**/
immutable VertexCode = q{
  #version 450 core

  layout (location = 0) in vec3 lPosition;
  layout (location = 1) in vec2 lTexCoord;

  out vec2 tTexCoord0;

  uniform mat4 uModel;
  uniform mat4 uView;
  uniform mat4 uProjection;

  void main() {
    gl_Position = uProjection * uView * uModel * vec4(lPosition, 1.0);
    tTexCoord0 = lTexCoord;
  }
};

/**
 *
**/
immutable FragmentCode = q{
  #version 450 core

  in vec2 tTexCoord0;

  uniform vec3 uColor;
  uniform sampler2D uTextureSampler;

  void main() {
    gl_FragColor = texture2D(uTextureSampler, tTexCoord0.xy) * vec4(uColor, 1.0);
  }
};