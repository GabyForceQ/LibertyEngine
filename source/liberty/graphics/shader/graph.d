/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/graph.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.graph;

import liberty.graphics.shader.constants;
import liberty.graphics.shader.factory;
import liberty.graphics.shader.impl;

final class GfxShaderGraph : IGfxShaderFactory {
  private {
    string id;
    string vertexCode;
    string fragmentCode;

    GfxShaderProgram program;
    string[] attributes;
    string[] uniforms;
    string[] samplers;
  }

  this(string id) {
    this.id = id;
    program = new GfxShaderProgram;
  }

  string getId() pure nothrow const {
    return id;
  }

  GfxShaderProgram getProgram() pure nothrow {
    return program;
  }

  typeof(this) addVertexCode(string code) pure nothrow {
    vertexCode = GFX_SHADER_CORE_VERSION ~ code;
    return this;
  }

  typeof(this) addFragmentCode(string code) pure nothrow {
    fragmentCode = GFX_SHADER_CORE_VERSION ~ code;
    return this;
  }

  bool hasVertexProgram() pure nothrow const {
    return vertexCode != "";
  }

  bool hasFragmentProgram() pure nothrow const {
    return fragmentCode != "";
  }

  typeof(this) build() {
    fillBuffers();

    program
      .compileShaders(vertexCode, fragmentCode)
      .linkShaders;

    foreach (a; attributes)
      program.bindAttribute(a);

    program.bind;

    foreach (u; uniforms)
      program.addUniform(u);

    foreach (int i, s; samplers)
      program.loadUniform(s, i);

    program.unbind;

    return this;
  }

  private void fillBuffers() {
    import std.array : split;
    import std.conv : to;

    // TODO. Possible \r
    char[][] vertLines = (cast(char[])vertexCode).split("\n");
    
    foreach (line; vertLines) {
      char[][] vertTok = line.split(" ");
      foreach (i, tok; vertTok)
        if (tok == "in")
          attributes ~= vertTok[i + 2][0 .. $ - 1].to!string;
        else if (tok == "uniform") {
          if (vertTok[i + 2][$ - 2] == ']') {
            const arrLen = vertTok[i + 2][$ - 3].to!string.to!int;
            foreach (j; 0..arrLen)
              uniforms ~= vertTok[i + 2][0 .. $ - 4].to!string ~ "[" ~ j.to!string ~ "]";
          } else
            uniforms ~= vertTok[i + 2][0 .. $ - 1].to!string;
        }
    }

    // TODO. Possible \r
    char[][] fragLines = (cast(char[])fragmentCode).split("\n");

    foreach (line; fragLines) {
      char[][] fragTok = line.split(" ");
      foreach (i, tok; fragTok)
        if (tok == "uniform") {
          if (fragTok[i + 2][$ - 2] == ']') {
            const arrLen = fragTok[i + 2][$ - 3].to!string.to!int;
            foreach (j; 0..arrLen) {
              uniforms ~= fragTok[i + 2][0 .. $ - 4].to!string ~ "[" ~ j.to!string ~ "]";
              if (fragTok[i + 1] == "sampler2D" || fragTok[i + 1] == "samplerCube")
                samplers ~= fragTok[i + 2][0 .. $ - 1].to!string;
            }
          } else {
            uniforms ~= fragTok[i + 2][0 .. $ - 1].to!string;
            if (fragTok[i + 1] == "sampler2D" || fragTok[i + 1] == "samplerCube")
              samplers ~= fragTok[i + 2][0 .. $ - 1].to!string;
          }
        }
    }
  }
}