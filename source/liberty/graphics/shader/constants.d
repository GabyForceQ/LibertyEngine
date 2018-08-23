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
immutable vertex3Color = q{
  #version 450 core

  layout (location = 0) in vec3 position;

  out vec4 tColor;

  uniform mat4 uTransform;

  void main() {
    tColor = vec4(clamp(position, 0.0, 1.0), 1.0);
    gl_Position = uTransform * vec4(position, 1.0);
  }
};

/**
 *
**/
immutable fragmentColor = q{
  #version 450 core

  in vec4 tColor;

  out vec4 rColor;

  void main() {
    rColor = tColor;
  }
};

/**
 *
**/
immutable vertexColor1 = q{
  #version 450 core

  in vec2 vertexPosition;
  in vec4 vertexColor;
  in vec2 texCoords;

  out vec4 tColor;
  out vec2 tTexCoords;

  uniform mat4 uOrthoProjection;

  void main() {
    gl_Position.xy = (uOrthoProjection * vec4(vertexPosition, 0.0, 1.0)).xy;
    gl_Position.z = 0.0;
    gl_Position.w = 1.0;
    tColor = vertexColor;
    tTexCoords = vec2(texCoords.x, 1.0 - texCoords.y);
  }
};

/**
 *
**/
immutable fragmentColor1 = q{
  #version 450 core

  in vec4 tColor;
  in vec2 tTexCoords;

  out vec4 rColor;

  uniform float uTime;
  uniform sampler2D uTexture;

  void main() {
    vec4 textureColor = texture(uTexture, tTexCoords);

    //rColor = textureColor * vec4(
    //    1.0 * (cos(uTime + 0.0) + 1.0) * 0.5,
    //    1.0 * (cos(uTime + 2.0) + 1.0) * 0.5,
    //    1.0 * (sin(uTime + 1.0) + 1.0) * 0.5,
    //    0.0
    //);

    rColor = textureColor;
  }
};