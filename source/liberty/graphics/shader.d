/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.core.engine : CoreEngine;
import liberty.logger : Logger;
import liberty.math.vector : Vector2F, Vector3F, Vector4F;
import liberty.math.matrix : Matrix4F;

/**
 *
**/
class Shader {
  private {
    uint programID;
    uint vertexShaderID;
    uint fragmentShaderID;
    int attributeCount;
    int[string] uniforms;
  }

  /**
   *
  **/
  uint getId() pure nothrow const {
    return programID;
  }

  /**
   *
  **/
  Shader bind() {
    version (__OPENGL__)
      glUseProgram(this.programID);    

    return this;
  }

  /**
   *
  **/
  Shader unbind() {
    version (__OPENGL__)
      glUseProgram(0);

    return this;
  }

  /**
   *
  **/
  Shader bindAttribute(string name) {
    import std.string : toStringz;

    version (__OPENGL__)
      glBindAttribLocation(this.programID, this.attributeCount++, name.toStringz);

    return this;
  }

  /**
   *
  **/
  Shader compileShaders(string vertexShader, string fragmentShader) {
    // Create program
    version (__OPENGL__)
      this.programID = glCreateProgram();

    // Load shaders
    this.vertexShaderID = loadShader(vertexShader, ShaderType.Vertex);
    this.fragmentShaderID = loadShader(fragmentShader, ShaderType.Fragment);

    return this;
  }

  /**
   *
  **/
  Shader linkShaders() {
    version (__OPENGL__) {
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
        Logger.error("Failed to link shaders", typeof(this).stringof);
      }

      // Detach shaders after a successful link
      glDetachShader(this.programID, this.vertexShaderID);
      glDetachShader(this.programID, this.fragmentShaderID,);

      // Delete shaders. We don't need them anymore because they are linked
      glDeleteShader(this.vertexShaderID);
      glDeleteShader(this.fragmentShaderID);
    }

    return this;
  }

  /**
   *
  **/
  Shader addUniform(string name) {
    import std.string : toStringz;
    
    version (__OPENGL__) {
      immutable location = glGetUniformLocation(this.programID, name.toStringz);
      if (location == GL_INVALID_VALUE) {
        Logger.error("Could not find uniform: " ~ name, typeof(this).stringof);
      }
    }
    else
      immutable location = 0;

    this.uniforms[name] = location;

    return this;
  }

  /**
   * Load bool uniform using location id and value.
  **/
  Shader loadUniform(int locationID, bool value) nothrow {
    version (__OPENGL__)
      glUniform1i(locationID, cast(int)value);

    return this;
  }

  /**
   * Load int uniform using location id and value.
  **/
  Shader loadUniform(int locationID, int value) nothrow {
    version (__OPENGL__)
      glUniform1i(locationID, value);

    return this;
  }

  /**
   * Load uint uniform using location id and value.
  **/
  Shader loadUniform(int locationID, uint value) nothrow {
    version (__OPENGL__)
      glUniform1ui(locationID, value);

    return this;
  }

  /**
   * Load float uniform using location id and value.
  **/
  Shader loadUniform(int locationID, float value) nothrow {
    version (__OPENGL__)
      glUniform1f(locationID, value);

    return this;
  }

  /**
   * Load Vector2F uniform using location id and value.
  **/
  Shader loadUniform(int locationID, Vector2F vector) nothrow {
    version (__OPENGL__)
      glUniform2f(locationID, vector.x, vector.y);

    return this;
  }

  /**
   * Load Vector3F uniform using location id and value.
  **/
  Shader loadUniform(int locationID, Vector3F vector) nothrow {
    version (__OPENGL__)
      glUniform3f(locationID, vector.x, vector.y, vector.z);

    return this;
  }

  /**
   * Load Vector4F uniform using location id and value.
  **/
  Shader loadUniform(int locationID, Vector4F vector) nothrow {
    version (__OPENGL__)
      glUniform4f(locationID, vector.x, vector.y, vector.z, vector.w);
    
    return this;
  }

  /**
   * Load Matrix4F uniform using location id and value.
  **/
  Shader loadUniform(int locationID, Matrix4F matrix) nothrow {
    //glUniform4fv(locationID, matrix.ptr); // TODO?
    //glUniformMatrix4fv(glGetUniformLocation(this.programID, cast(const(char)*)name), 1, GL_TRUE, matrix.ptr);
    return this;
  }

  /**
   * Load bool uniform using uniform name and value.
  **/
  Shader loadUniform(string name, bool value) nothrow {
    version (__OPENGL__)
      glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), cast(int)value);
    
    return this;
  }

  /**
   * Load int uniform using uniform name and value.
  **/
  Shader loadUniform(string name, int value) nothrow {
    version (__OPENGL__)
      glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
    
    return this;
  }

  /**
   * Load uint uniform using uniform name and value.
  **/
  Shader loadUniform(string name, uint value) nothrow {
    version (__OPENGL__)
      glUniform1ui(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
    
    return this;
  }

  /**
   * Load float uniform using uniform name and value.
  **/
  Shader loadUniform(string name, float value) nothrow {
    version (__OPENGL__)
      glUniform1f(this.uniforms[name], value);
    
    return this;
  }

  /**
   * Load Vector2F uniform using uniform name and value.
  **/
  Shader loadUniform(string name, Vector2F vector) nothrow {
    version (__OPENGL__)
      glUniform2f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y);
    
    return this;
  }

  /**
   * Load Vector3F uniform using uniform name and value.
  **/
  Shader loadUniform(string name, Vector3F vector) nothrow {
    version (__OPENGL__)
      glUniform3f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z);
    
    return this;
  }

  /**
   * Load Vector4F uniform using uniform name and value.
  **/
  Shader loadUniform(string name, Vector4F vector) nothrow {
    version (__OPENGL__)
      glUniform4f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z, vector.w);
    
    return this;
  }

  /**
   * Load Matrix4F uniform using uniform name and value.
  **/
  Shader loadUniform(string name, Matrix4F matrix) nothrow {
    version (__OPENGL__)
      glUniformMatrix4fv(glGetUniformLocation(this.programID, cast(const(char)*)name), 1, GL_TRUE, matrix.ptr);
    
    return this;
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
        version (__OPENGL__)
          shaderId = glCreateShader(GL_VERTEX_SHADER);
        break;

      case Fragment:
        version (__OPENGL__)
          shaderId = glCreateShader(GL_FRAGMENT_SHADER);
        break;
    }

    // Attach shader
    version (__OPENGL__)
      glShaderSource(
        shaderId, 
        cast(int)lineCount, 
        cast(const(char*)*)addresses.ptr, 
        cast(const(int)*)(lengths.ptr)
      );

    // Compile shader
    version (__OPENGL__)
      glCompileShader(shaderId);
    
    // Check shader compilation
    version (__OPENGL__) {
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
        Logger.error("Shader failed to compile: " ~ shaderCode, typeof(this).stringof);
        assert(0);
      }
    }

    return shaderId;
  }
}

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