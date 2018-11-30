/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.impl;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.core.engine;
import liberty.graphics.shader.constants;
import liberty.logger.impl;
import liberty.math.vector;
import liberty.math.matrix;
import liberty.model;

/**
 * Base shader class.
**/
abstract class GfxShader {
  private {
    uint programID;
    uint vertexShaderID;
    uint fragmentShaderID;
    int attributeCount;
    int[string] uniforms;
  }

  /**
   * Returns the shader id.
  **/
  final uint getId() pure nothrow const {
    return programID;
  }

  /**
   * Bind the shader into video memory.
   * Returns reference to this so it can be used in a stream.
  **/
  R bind(this R)() {
    version (__OPENGL__)
      glUseProgram(this.programID);    

    return cast(R)this;
  }

  /**
   * Unbind the shader from video memory.
   * Returns reference to this so it can be used in a stream.
  **/
  R unbind(this R)() {
    version (__OPENGL__)
      glUseProgram(0);

    return cast(R)this;
  }

  /**
   * Enable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R enableVertexAttributeArray(this R)(int vaoID) {
    glBindVertexArray(vaoID);

    foreach (i; 0..attributeCount)
      glEnableVertexAttribArray(i);

    return cast(R)this;
  }

  /**
   * Disable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R disableVertexAttributeArray(this R)() {
    foreach (i; 0..attributeCount)
      glDisableVertexAttribArray(i);
    
    glBindVertexArray(0);

    return cast(R)this;
  }

  /**
   * Bind a shader attribute into video memory.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) bindAttribute(string name) {
    import std.string : toStringz;

    version (__OPENGL__)
      glBindAttribLocation(programID, attributeCount++, name.toStringz);

    return this;
  }

  /**
   * Compile vertex and fragment shader using its code.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) compileShaders(string vertexShader, string fragmentShader) {
    // Create program
    version (__OPENGL__)
      this.programID = glCreateProgram();

    // Load shaders
    this.vertexShaderID = loadShader(vertexShader, GfxShaderType.VERTEX);
    this.fragmentShaderID = loadShader(fragmentShader, GfxShaderType.FRAGMENT);

    return this;
  }

  /**
   * Link shaders into video memory.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) linkShaders() {
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
   * Add a new shader uniform to the uniforms map using its name.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) addUniform(string name) {
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
   * Load a bool uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, bool value) nothrow {
    version (__OPENGL__)
      glUniform1i(locationID, cast(int)value);

    return this;
  }

  /**
   * Load an int uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, int value) nothrow {
    version (__OPENGL__)
      glUniform1i(locationID, value);

    return this;
  }

  /**
   * Load an uint uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, uint value) nothrow {
    version (__OPENGL__)
      glUniform1ui(locationID, value);

    return this;
  }

  /**
   * Load a float uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, float value) nothrow {
    version (__OPENGL__)
      glUniform1f(locationID, value);

    return this;
  }

  /**
   * Load a vec2 uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, Vector2F vector) nothrow {
    version (__OPENGL__)
      glUniform2f(locationID, vector.x, vector.y);

    return this;
  }

  /**
   * Load vec3 uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, Vector3F vector) nothrow {
    version (__OPENGL__)
      glUniform3f(locationID, vector.x, vector.y, vector.z);

    return this;
  }

  /**
   * Load vec4 uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, Vector4F vector) nothrow {
    version (__OPENGL__)
      glUniform4f(locationID, vector.x, vector.y, vector.z, vector.w);
    
    return this;
  }

  /**
   * Load Matrix4F uniform using location id and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(int locationID, Matrix4F matrix) nothrow {
    version (__OPENGL__)
      glUniformMatrix4fv(locationID, 1, GL_TRUE, matrix.ptr);
    return this;
  }

  /**
   * Load bool uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, bool value) nothrow {
    version (__OPENGL__)
      glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), cast(int)value);
    
    return this;
  }

  /**
   * Load int uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, int value) nothrow {
    version (__OPENGL__)
      glUniform1i(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
    
    return this;
  }

  /**
   * Load uint uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, uint value) nothrow {
    version (__OPENGL__)
      glUniform1ui(glGetUniformLocation(this.programID, cast(const(char)*)name), value);
    
    return this;
  }

  /**
   * Load float uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, float value) nothrow {
    version (__OPENGL__)
      glUniform1f(this.uniforms[name], value);
    
    return this;
  }

  /**
   * Load Vector2F uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, Vector2F vector) nothrow {
    version (__OPENGL__)
      glUniform2f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y);
    
    return this;
  }

  /**
   * Load Vector3F uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, Vector3F vector) nothrow {
    version (__OPENGL__)
      glUniform3f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z);
    
    return this;
  }

  /**
   * Load Vector4F uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, Vector4F vector) nothrow {
    version (__OPENGL__)
      glUniform4f(glGetUniformLocation(this.programID, cast(const(char)*)name), vector.x, vector.y, vector.z, vector.w);
    
    return this;
  }

  /**
   * Load Matrix4F uniform using uniform name and value.
   * Returns reference to this so it can be used in a stream.
  **/
  protected final typeof(this) loadUniform(string name, Matrix4F matrix) nothrow {
    version (__OPENGL__)
      glUniformMatrix4fv(glGetUniformLocation(this.programID, cast(const(char)*)name), 1, GL_TRUE, matrix.ptr);
    
    return this;
  }
  
  /**
   * Step1: Enable vertex attribute array for the model.
   * Step2: Render a model to the screen by calling render method from model.
   * Step3: Disable vertex attribute array.
   * Returns reference to this so it can be used in a stream.
  **/
  R render(this R)(Model model) {
    enableVertexAttributeArray(model.getRawModel.vaoID);

    loop0: foreach (i; 0..model.getMaterials.length) {
      switch (i) {
        case 0: glActiveTexture(GL_TEXTURE0); break;
        case 1: glActiveTexture(GL_TEXTURE1); break;
        case 2: glActiveTexture(GL_TEXTURE2); break;
        case 3: glActiveTexture(GL_TEXTURE3); break;
        case 4: glActiveTexture(GL_TEXTURE4); break;
        default: break loop0;
      }
      glBindTexture(GL_TEXTURE_2D, model.getMaterials[i].getTexture.getId);
    }

    model.render();

    loop1: foreach (i; 0..model.getMaterials.length) {
      switch (i) {
        case 0: glActiveTexture(GL_TEXTURE0); break;
        case 1: glActiveTexture(GL_TEXTURE1); break;
        case 2: glActiveTexture(GL_TEXTURE2); break;
        case 3: glActiveTexture(GL_TEXTURE3); break;
        case 4: glActiveTexture(GL_TEXTURE4); break;
        default: break loop1;
      }
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    disableVertexAttributeArray();

    return cast(R)this;
  }

  private uint loadShader(string shaderCode, GfxShaderType type) {
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
    final switch(type) with(GfxShaderType) {
      case VERTEX:
        version (__OPENGL__)
          shaderId = glCreateShader(GL_VERTEX_SHADER);
        break;

      case FRAGMENT:
        version (__OPENGL__)
          shaderId = glCreateShader(GL_FRAGMENT_SHADER);
        break;

      case GEOMETRY:
        Logger.todo("FEATURE NOT IMPLEMENTED YET", typeof(this).stringof);
        Logger.error("Previous todo", typeof(this).stringof);
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