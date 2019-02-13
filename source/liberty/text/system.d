/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.system;

import liberty.text.impl;
import liberty.text.renderer;
import liberty.text.shader;
import liberty.scene.impl;

/**
 * System class holding basic text functionality.
 * It contains references to the $(D TextRenderer), $(D TextShader) and $(D Scene).
 * It also contains a map with all texts in the current scene.
**/
final class TextSystem {
  private {
    TextRenderer renderer;
    //TextShader shader;
    Text[string] map;
    Scene scene;
  }

  /**
   * Create and initialize text system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    //shader = new TextShader();
    renderer = new TextRenderer(this, scene);
  }

  /**
   * Register a text entity to the text system.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(Text entity)   {
    //map[entity.getId] = entity;
    return this;
  }

  /**
   * Remove the given text entity from the text map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(Text entity)   {
    //map.remove(entity.getId);
    return this;
  }

  /**
   * Remove the text entity that has the given id from the text map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id)   {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the text map.
  **/
  Text[string] getMap()   {
    return map;
  }

  /**
   * Returns the text element in the map that has the given id.
  **/
  Text getElementById(string id)   {
    return map[id];
  }

  /**
   * Returns a text renderer reference.
  **/
  TextRenderer getRenderer()   {
    return renderer;
  }

  /**
   * Returns a text shader reference.
  **/
  //TextShader getShader()   {
  //  return shader;
  //}
}