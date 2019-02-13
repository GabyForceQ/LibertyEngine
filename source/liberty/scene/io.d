/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.io;

import std.array : split;
import std.conv : to;
import std.stdio : File;
import std.string : strip;
import core.stdc.stdio : sscanf;

import liberty.framework.light.impl;
import liberty.framework.primitive.impl;
import liberty.framework.terrain.impl;
import liberty.material.impl;
import liberty.math.transform;
import liberty.scene.impl;
import liberty.scene.services;

/**
 * Used for input/output operations on $(D Scene) class.
 * It implements $(D ISerializable) service.
**/
abstract class SceneIO : ISerializable {
  /**
   * Serialize a scene.
  **/
  static void serialize(Scene scene) {
    // Open the file
    auto file = File(scene.relativePath, "w");
    scope(exit) file.close;

    file.writeln("id: " ~ scene.id);

    foreach (Primitive entity; cast(Primitive[string])scene.shaderMap["Primitive"].getMap) {
      file.writeln(
        "Primitive: { " ~
          "id: " ~ entity.id ~
          "transform: [ " ~
            "location: " ~ entity.component!Transform.getLocation.toString ~ 
        " ] }"
      );
    }

    foreach (Terrain entity; cast(Terrain[string])scene.shaderMap["Terrain"].getMap) {
      file.writeln(
        "Terrain: { " ~
          "id: " ~ entity.id ~
          " , size: " ~ entity.getSize.to!string ~
          " , maxHeight " ~ entity.getMaxHeight.to!string ~
          " , materials: [ " ~
            entity.model.materials[0].getTexture.getRelativePath ~
            " , " ~ entity.model.materials[1].getTexture.getRelativePath ~
            " , " ~ entity.model.materials[2].getTexture.getRelativePath ~
            " , " ~ entity.model.materials[3].getTexture.getRelativePath ~
            " , " ~ entity.model.materials[4].getTexture.getRelativePath ~
        " ] }"
      );
    }

    /*foreach (entity; scene.getGuiSystem.getMap) {
      file.writeln(
        "Widget: { " ~
          "id: " ~ entity.getId ~
        " }"
      );
    }*/

    foreach (Light entity; cast(Light[string])scene.shaderMap["Light"].getMap) {
      file.writeln(
        "Light: { " ~
          "id: " ~ entity.id ~
        " }"
      );
    }
  }

  /**
   * Deserialize a scene.
  **/
  static void deserialize(Scene scene) {
    // Open the file
    auto file = File(scene.relativePath);
    scope(exit) file.close;

    // Read the file and build scene
    auto range = file.byLine();
    foreach (line; range) {
      line = line.strip();
      const char[][] tokens = line.split(" ").dup;
      if (tokens.length == 0)
        continue;
      else if (tokens[0] == "id:")
        scene.id = cast(string)tokens[1].dup;
      else if (tokens[0] == "Terrain:")
        scene.spawn!Terrain(cast(string)tokens[3].dup)
          .build(tokens[6].dup.to!float, tokens[9].dup.to!float, [
            new Material(cast(string)tokens[13].dup),
            new Material(cast(string)tokens[15].dup),
            new Material(cast(string)tokens[17].dup),
            new Material(cast(string)tokens[19].dup),
            new Material(cast(string)tokens[21].dup)
          ]);
      else if (tokens[0] == "Light:")
        scene.spawn!Light(cast(string)tokens[3].dup);
    }
  }
}