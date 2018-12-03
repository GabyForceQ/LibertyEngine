/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.impl;

import liberty.graphics.shader.constants;
import liberty.graphics.shader.factory;
import liberty.graphics.shader.program;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.node;
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

    SceneNode[string] map;
    ShaderProgram program;
    void delegate(ShaderProgram program) onGlobalRender;
    void delegate(ShaderProgram program) onPerEntityRender;
    
    bool hasViewMatrix;
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
   * Register a node to the renderer.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(SceneNode node) pure nothrow {
    map[node.getId] = node;
    return this;
  }

  /**
   * Remove the given node from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(SceneNode node) pure nothrow {
    map.remove(node.getId);
    return this;
  }

  /**
   * Remove the node that has the given id from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the map.
  **/
  SceneNode[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the element in the map that has the given id.
  **/
  SceneNode getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Add global render delegate so it can be called every render tick once for all map elements.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addGlobalRender(void delegate(ShaderProgram) dg) {
    onGlobalRender = dg;
    return this;
  }

  /**
   * Add per entity render delegate so it can be called every render tick for every map element.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) addPerEntityRender(void delegate(ShaderProgram) dg) {
    onPerEntityRender = dg;
    return this;
  }

  /**
   * Render all map elements to the screen.
  **/
  void render(Scene scene) {
    auto camera = scene.getActiveCamera;

    program
      .bind
      .loadUniform("uProjectionMatrix", camera.getProjectionMatrix);

    if (hasViewMatrix)
      program.loadUniform("uViewMatrix", camera.getViewMatrix);

    if (onGlobalRender !is null)
      onGlobalRender(program);
    
    foreach (node; map)
      if (node.getVisibility == Visibility.Visible)
        render(node);

    program.unbind;
  }

  private void render(SceneNode node) 
  in (node !is null, "You cannot render a null scene node.")
  do {
    auto model = node.getModel;

    if (model !is null) {
      program.loadUniform("uModelMatrix", node.getTransform.getModelMatrix);

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
              hasViewMatrix = true;
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