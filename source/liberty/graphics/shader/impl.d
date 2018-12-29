/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.impl;

import liberty.math.transform;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.factory;
import liberty.graphics.shader.program;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.entity;
import liberty.scene.services;

/**
 *
**/
final class Shader : IShaderFactory, IRenderable {
  private {
    string id;
    string vertexCode;
    string fragmentCode;

    string[] attributes;
    string[] uniforms;
    string[] samplers;

    Entity[string] map;
    ShaderProgram program;
    void delegate(ShaderProgram program, typeof(this) self) onCustomRender;
    void delegate(ShaderProgram program) onGlobalRender;
    void delegate(ShaderProgram program) onPerEntityRender;
    
    bool viewMatrixEnabled;
  }

  /**
   * Create a new shader program with empty map and id.
  **/
  this(string id) {
    this.id = id;
    program = new ShaderProgram;
  }

  /**
   * Returns shader id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Add vertex code.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addVertexCode(string code) pure nothrow {
    vertexCode = GFX_SHADER_CORE_VERSION ~ code;
    return this;
  }

  /**
   * Add fragment code.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addFragmentCode(string code) pure nothrow {
    fragmentCode = GFX_SHADER_CORE_VERSION ~ code;
    return this;
  }

  /**
   * Returns true if vertex code exists.
  **/
  bool hasVertexProgram() pure nothrow const {
    return vertexCode != "";
  }

  /**
   * Returns true if fragement code exists.
  **/
  bool hasFragmentProgram() pure nothrow const {
    return fragmentCode != "";
  }

  /**
   * Build shader data, compile and link.
   * Returns reference to this so it can be used in a stream.
  **/
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

  /**
   * Returns the shader program from the map.
  **/
  ShaderProgram getProgram() pure nothrow {
    return program;
  }

  /**
   * Register a entity to the renderer.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerEntity(Entity entity) pure nothrow {
    map[entity.getId] = entity;
    return this;
  }

  /**
   * Remove the given entity from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeEntity(Entity entity) pure nothrow {
    map.remove(entity.getId);
    return this;
  }

  /**
   * Remove the entity that has the given id from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeEntityById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all entities in the map.
  **/
  Entity[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the entity in the map that has the given id.
  **/
  Entity getEntityById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Add custom render delegate so it can be called every render tick.
   * If this is not null, then globalRender and perEntityRender are useless.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addCustomRenderMethod(void delegate(ShaderProgram, typeof(this) self) dg) pure nothrow {
    onCustomRender = dg;
    return this;
  }

  /**
   * Add global render delegate so it can be called every render tick once for all map entities.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addGlobalRenderMethod(void delegate(ShaderProgram) dg) pure nothrow {
    onGlobalRender = dg;
    return this;
  }

  /**
   * Add per entity render delegate so it can be called every render tick for every map entity.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addPerEntityRenderMethod(void delegate(ShaderProgram) dg) pure nothrow {
    onPerEntityRender = dg;
    return this;
  }

  /**
   * Set if view matrix is enabled on this shader.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setViewMatrixEnabled(bool enabled = true) pure nothrow {
    viewMatrixEnabled = enabled;
    return this;
  }

  /**
   * Returns true if view matrix is enabled on this shader.
  **/
  bool isViewMatrixEnabled() pure nothrow const {
    return viewMatrixEnabled;
  }

  /**
   * Render all map entities to the screen.
  **/
  void render(Scene scene) {
    if (onCustomRender !is null)
      onCustomRender(program, this);
    else {
      auto camera = scene.getActiveCamera;

      program
        .bind
        .loadUniform("uProjectionMatrix", camera.getProjectionMatrix);

      if (viewMatrixEnabled)
        program.loadUniform("uViewMatrix", camera.getViewMatrix);

      if (onGlobalRender !is null)
        onGlobalRender(program);
      
      foreach (entity; map)
        if (entity.getVisibility == Visibility.Visible)
          render(entity);

      program.unbind;
    }
  }

  private void render(Entity entity) 
  in (entity !is null, "You cannot render a null scene entity.")
  do {
    auto model = entity.getModel;

    if (model !is null) {
      program.loadUniform("uModelMatrix", entity.getComponent!Transform.getModelMatrix);

      if (onPerEntityRender !is null)
        onPerEntityRender(program);
      
      program.render(model);
    }
  }

  private void fillBuffers() {
    import std.array : split;
    import std.conv : to;

    // TODO. Possible \r
    // Parse vertex shader
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
          } else {
            uniforms ~= vertTok[i + 2][0 .. $ - 1].to!string;
            if (uniforms[$ - 1] == "uViewMatrix")
              viewMatrixEnabled = true;
          }
        }
    }

    // Parse fragment shader
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