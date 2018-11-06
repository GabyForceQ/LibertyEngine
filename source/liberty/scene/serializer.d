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

import liberty.logger;

/**
 *
**/
class SceneSerializer : ISerializable {
  private {
    Scene scene;
    string path;
  }

  /**
   *
  **/
  this(string path) pure nothrow {
    this.path = path;
  }

  /**
   *
  **/
  SceneSerializer registerScene(Scene scene) pure nothrow {
    this.scene = scene;
    return this;
  }

  /**
   *
  **/
  void serialize() {
    // Open the file
    auto file = File(path);
    scope (exit) file.close();
  }

  /**
   *
  **/
  void deserialize() {
    // Open the file
    auto file = File(path);
    scope (exit) file.close();

    // Read the file and build scene
    auto range = file.byLine();
    foreach (line; range) {
      line = line.strip();
      const char[][] tokens = line.split(" ").dup;
      if (tokens.length == 0)
        continue;
      else if (tokens[0] == "id:")
        scene.setId(cast(string)tokens[1].dup);
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
   *
  **/
  Scene getScene() pure nothrow {
    return scene;
  }

  /**
   *
  **/
  SceneSerializer setFilePath(string path) pure nothrow {
    this.path = path;
    return this;
  }

  /**
   *
  **/
  string getFilePath() pure nothrow const {
    return path;
  }
}