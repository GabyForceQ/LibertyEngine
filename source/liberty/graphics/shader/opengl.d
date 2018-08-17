/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/opengl.d, _opengl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.opengl;

import derelict.opengl;

import liberty.core.logger.manager : Logger;
import liberty.graphics.shader.constants : ShaderType;
import liberty.graphics.shader.gfx : GfxShaderProgram;

/**
 *
**/
class GLShaderProgram : GfxShaderProgram {
  /**
   *
  **/
  this() @safe {
    super();
  }

  /**
   *
  **/
  void use() {
    glUseProgram(_programID);
    foreach (i; 0.._attributeCount) {
      glEnableVertexAttribArray(i);
    }
  }

  /**
   *
  **/
  void unuse() {
    glUseProgram(0);
    foreach (i; 0.._attributeCount) {
      glDisableVertexAttribArray(i);
    }
  }

  /**
   *
  **/
  void addAttribute(string name) {
    import std.string : toStringz;
    glBindAttribLocation(_programID, _attributeCount++, name.toStringz);
  }

  /**
   *
  **/
  void compileShaders(string vertexShader, string fragmentShader) {
    // Create program
    _programID = glCreateProgram();
    
    // Load shaders
    _vertexShaderID = loadShader(vertexShader, ShaderType.Vertex);
    _fragmentShaderID = loadShader(fragmentShader, ShaderType.Fragment);
  }

  /**
   *
  **/
  void linkShaders() {
    // Attach shaders to program
    glAttachShader(_programID, _vertexShaderID);
    glAttachShader(_programID, _fragmentShaderID);

    // Link program
    glLinkProgram(_programID);

    // Check program link
    GLint isLinked;
    glGetProgramiv(_programID, GL_LINK_STATUS, cast(int*)&isLinked);
    if (isLinked == GL_FALSE) {
      // Get error information
      GLint maxLength;
      glGetProgramiv(_programID, GL_INFO_LOG_LENGTH, &maxLength);
      char[] errorLog = new char[maxLength];
      glGetShaderInfoLog(_programID, maxLength, &maxLength, errorLog.ptr);

      // Delete program
      glDeleteProgram(_programID);

      // Delete shaders too
      glDeleteShader(_vertexShaderID);
      glDeleteShader(_fragmentShaderID);

      // Log the error
      Logger.self.error("Failed to link shaders", typeof(this).stringof);
      assert(0);
    }

    // Detach shaders after a successful link
    glDetachShader(_programID, _vertexShaderID);
    glDetachShader(_programID, _fragmentShaderID);

    // Delete shaders. We don't need them anymore because they are linked
    glDeleteShader(_vertexShaderID);
    glDeleteShader(_fragmentShaderID);
  }

  /**
   *
  **/
  int getUniformLocation(string name) {
    import std.string : toStringz;
    immutable int location = glGetUniformLocation(_programID, name.toStringz);
    if (location == GL_INVALID_INDEX) {
      assert(0);
    }
    return location;
  }

  private uint loadShader(string shaderCode, ShaderType type) {
    import std.string : splitLines;

    // Get info about shader code
    string[] lines = splitLines(shaderCode);
    size_t lineCount = lines.length;
    auto lengths = new int[lineCount];
    auto addresses = new immutable(char)*[lineCount];
    auto localLines = new string[lineCount];

    // Build data
    for (size_t i; i < lineCount; i++) {
      localLines[i] = lines[i] ~ "\n";
      lengths[i] = cast(int)(localLines[i].length);
      addresses[i] = localLines[i].ptr;
    }
    
    // Create shader
    int shaderId;
    final switch(type) with(ShaderType) {
      case Vertex:
        shaderId = glCreateShader(GL_VERTEX_SHADER);
        break;
      case Fragment:
        shaderId = glCreateShader(GL_FRAGMENT_SHADER);
        break;
    }

    // Attach shader
    glShaderSource(
      shaderId, 
      cast(int)lineCount, 
      cast(const(char*)*)addresses.ptr, 
      cast(const(int)*)(lengths.ptr)
    );

    // Compile shader
    glCompileShader(shaderId);
    
    // Check shader compilation
    GLint success;
    glGetShaderiv(shaderId, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
      // Get error information
      GLint maxLength;
      glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &maxLength);
      char[] errorLog = new char[maxLength];
      glGetShaderInfoLog(shaderId, maxLength, &maxLength, errorLog.ptr);

      // Delete shader
      glDeleteShader(shaderId);

      // Log the error
      Logger.self.error("Shader failed to compile", typeof(this).stringof);
      Logger.self.error(shaderCode, typeof(this).stringof);
      assert(0);
    }

    return shaderId;
  }
}