/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/serializer.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.serializer;

import std.array : split;
import std.conv : to;
import std.stdio : File;
import std.string : strip;
import core.stdc.stdio : sscanf;

import liberty.scene.impl;
import liberty.services;
import liberty.terrain.impl;
import liberty.light.point;
import liberty.graphics.material.impl;

/**
 * Class used to serialize and deserialize a scene.
 * It implements $(D ISerializable) service.
**/
final class SceneSerializer : ISerializable {
  private {
    // getScene, setScene
    Scene scene;
    // getRelativePath, setRelativePath
    string path;
  }

  /**
   * Construct a serializer with a relative file path of the scene.
  **/
  this(string relativePath) pure nothrow {
    path = relativePath;
  }

  /**
   * Serialize the scene.
  **/
  void serialize() {
    // Open the file
    auto file = File(path, "w");
    scope(exit) file.close();

    file.writeln("id: " ~ scene.getId());

    foreach (node; scene.getPrimitiveSystem().getMap()) {
      file.writeln(
        "Primitive: { " ~
          "id: " ~ node.getId() ~
          "transform: [ " ~
            "location: " ~ node.getTransform().getAbsoluteLocation().toString() ~ 
        " ] }"
      );
    }

    foreach (node; scene.getTerrainSystem().getMap()) {
      file.writeln(
        "Terrain: { " ~
          "id: " ~ node.getId() ~
          " , size: " ~ node.getSize().to!string ~
          " , maxHeight " ~ node.getMaxHeight().to!string ~
          " , materials: [ " ~
            node.getRenderer().getModel().getMaterials[0].getTexture().getRelativePath() ~
            " , " ~ node.getRenderer().getModel().getMaterials[1].getTexture().getRelativePath() ~
            " , " ~ node.getRenderer().getModel().getMaterials[2].getTexture().getRelativePath() ~
            " , " ~ node.getRenderer().getModel().getMaterials[3].getTexture().getRelativePath() ~
            " , " ~ node.getRenderer().getModel().getMaterials[4].getTexture().getRelativePath() ~
        " ] }"
      );
    }

    foreach (node; scene.getSurfaceSystem().getMap()) {
      file.writeln(
        "Widget: { " ~
          "id: " ~ node.getId() ~
        " }"
      );
    }

    foreach (node; scene.getLightingSystem().getMap()) {
      file.writeln(
        "PointLight: { " ~
          "id: " ~ node.getId() ~
        " }"
      );
    }
  }

  /**
   * Deserialize the scene.
  **/
  void deserialize() {
    // Open the file
    auto file = File(path);
    scope(exit) file.close();

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
        scene.getTree().spawn!Terrain(cast(string)tokens[3].dup)
          .build(tokens[6].dup.to!float, tokens[9].dup.to!float, [
            new Material(cast(string)tokens[13].dup),
            new Material(cast(string)tokens[15].dup),
            new Material(cast(string)tokens[17].dup),
            new Material(cast(string)tokens[19].dup),
            new Material(cast(string)tokens[21].dup)
          ]);
      else if (tokens[0] == "PointLight:")
        scene.getTree().spawn!PointLight(cast(string)tokens[3].dup);
    }
  }

  /**
   * Set a $(D Scene) to the scene serializer.
   * Returns reference to this so it can be used in a stream.
  **/
  SceneSerializer setScene(Scene scene) pure nothrow {
    this.scene = scene;
    return this;
  }

  /**
   * Returns a reference of scene.
   * See $(D Scene).
  **/
  Scene getScene() pure nothrow {
    return scene;
  }

  /**
   * Set the relative path of the scene file using a string.
   * Returns reference to this so it can be used in a stream.
  **/
  SceneSerializer setRelativePath(string path) pure nothrow {
    this.path = path;
    return this;
  }

  /**
   * Returns the relative path of the scene file.
  **/
  string getRelativePath() pure nothrow const {
    return path;
  }
}