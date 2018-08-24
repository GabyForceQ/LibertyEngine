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

import liberty.core.math.vector : Vector2F, Vector3F, Vector4F;
import liberty.core.math.matrix : Matrix4F;

/**
 *
**/
class GLShaderProgram : GfxShaderProgram {
  /**
   *
  **/
  override void bind() {
    glUseProgram(this.programID);
    foreach (i; 0..this.attributeCount) {
      glEnableVertexAttribArray(i);
    }
  }

  /**
   *
  **/
  override void unbind() {
    glUseProgram(0);
    foreach (i; 0..this.attributeCount) {
      glDisableVertexAttribArray(i);
    }
  }

  /**
   *
  **/
  override void addAttribute(string name) {
    import std.string : toStringz;
    glBindAttribLocation(this.programID, this.attributeCount++, name.toStringz);
  }

  /**
   *
  **/
  override void compileShaders(string vertexShader, string fragmentShader) {
    // Create program
    this.programID = glCreateProgram();
    
    // Load shaders
    this.vertexShaderID = loadShader(vertexShader, ShaderType.Vertex);
    this.fragmentShaderID = loadShader(fragmentShader, ShaderType.Fragment);
  }

  /**
   *
  **/
  override void linkShaders() {
    // Attach shaders to program
    glAttachShader(this.programID, this.vertexShaderID);
    glAttachShader(this.programID, this.fragmentShaderID,);

    // Link program
    glLinkProgram(this.programID);

    // Check program link
    GLint isLinked;
    glGetProgramiv(this.programID, GL_LINK_STATUS, cast(int*)&isLinked);
    if (isLinked == GL_FALSE) {
      // Get error information
      GLint maxLength;
      glGetProgramiv(this.programID, GL_INFO_LOG_LENGTH, &maxLength);
      char[] errorLog = new char[maxLength];
      glGetShaderInfoLog(this.programID, maxLength, &maxLength, errorLog.ptr);

      // Delete program
      glDeleteProgram(this.programID);

      // Delete shaders too
      glDeleteShader(this.vertexShaderID);
      glDeleteShader(this.fragmentShaderID,);

      // Log the error
      Logger.self.error("Failed to link shaders", typeof(this).stringof);
    }

    // Detach shaders after a successful link
    glDetachShader(this.programID, this.vertexShaderID);
    glDetachShader(this.programID, this.fragmentShaderID,);

    // Delete shaders. We don't need them anymore because they are linked
    glDeleteShader(this.vertexShaderID);
    glDeleteShader(this.fragmentShaderID,);
  }

  /**
   *
  **/
  override void addUniform(string name) {
    import std.string : toStringz;
    immutable location = glGetUniformLocation(this.programID, name.toStringz);
    if (location == GL_INVALID_INDEX) {
      Logger.self.error("Could not find uniform: " ~ name, typeof(this).stringof);
    }
    this.uniforms[name] = location;
  }

  /**
   * Load bool uniform using location id and value.
  **/
  override void loadUniform(int locationID, bool value) nothrow @trusted {
    glUniform1i(locationID, cast(int)value);
  }

  /**
   * Load int uniform using location id and value.
  **/
  override void loadUniform(int locationID, int value) nothrow @trusted {
    glUniform1i(locationID, value);
  }

  /**
   * Load uint uniform using location id and value.
  **/
  override void loadUniform(int locationID, uint value) nothrow @trusted {
    glUniform1ui(locationID, value);
  }

  /**
   * Load float uniform using location id and value.
  **/
  override void loadUniform(int locationID, float value) nothrow @trusted {
    glUniform1f(locationID, value);
  }

  /**
   * Load Vector2F uniform using location id and value.
  **/
  override void loadUniform(int locationID, Vector2F vector) nothrow @trusted {
    glUniform2f(locationID, vector.x, vector.y);
  }

  /**
   * Load Vector3F uniform using location id and value.
  **/
  override void loadUniform(int locationID, Vector3F vector) nothrow @trusted {
    glUniform3f(locationID, vector.x, vector.y, vector.z);
  }

  /**
   * Load Vector4F uniform using location id and value.
  **/
  override void loadUniform(int locationID, Vector4F vector) nothrow @trusted {
    glUniform4f(locationID, vector.x, vector.y, vector.z, vector.w);
  }

  /**
   * Load Matrix4F uniform using location id and value.
  **/
  override void loadUniform(int locationID, Matrix4F matrix) nothrow @trusted {
    //glUniform4fv(locationID, matrix.ptr); // TODO?
  }

  /**
   * Load bool uniform using uniform name and value.
  **/
  override void loadUniform(string name, bool value) nothrow @trusted {
    glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), cast(int)value);
  }

  /**
   * Load int uniform using uniform name and value.
  **/
  override void loadUniform(string name, int value) nothrow @trusted {
    glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
  }

  /**
   * Load uint uniform using uniform name and value.
  **/
  override void loadUniform(string name, uint value) nothrow @trusted {
    glUniform1ui(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
  }

  /**
   * Load float uniform using uniform name and value.
  **/
  override void loadUniform(string name, float value) nothrow @trusted {
    glUniform1f(this.uniforms[name], value);
  }

  /**
   * Load Vector2F uniform using uniform name and value.
  **/
  override void loadUniform(string name, Vector2F vector) nothrow @trusted {
    glUniform2f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y);
  }

  /**
   * Load Vector3F uniform using uniform name and value.
  **/
  override void loadUniform(string name, Vector3F vector) nothrow @trusted {
    glUniform3f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z);
  }

  /**
   * Load Vector4F uniform using uniform name and value.
  **/
  override void loadUniform(string name, Vector4F vector) nothrow @trusted {
    glUniform4f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z, vector.w);
  }

  /**
   * Load Matrix4F uniform using uniform name and value.
  **/
  override void loadUniform(string name, Matrix4F matrix) nothrow @trusted {
    glUniformMatrix4fv(glGetUniformLocation(this.programID, cast(const(char)*)name), 1, GL_TRUE, matrix.ptr);
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