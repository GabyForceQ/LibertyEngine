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
    auto file = File(path, "w");
    scope(exit) file.close();

    import std.stdio;
    writeln(path);

    file.writeln("id: " ~ scene.getId());

    foreach (node; scene.getPrimitiveMap()) {
      file.writeln(
        "Primitive: { " ~
          "id: " ~ node.getId() ~
          "transform: [ " ~
            "location: " ~ node.getTransform().getAbsoluteLocation().toString() ~ 
        " ] }"
      );
    }

    foreach (node; scene.getTerrainMap()) {
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

    foreach (node; scene.getSurfaceMap()) {
      file.writeln(
        "Widget: { " ~
          "id: " ~ node.getId() ~
        " }"
      );
    }

    foreach (node; scene.getLightMap()) {
      file.writeln(
        "PointLight: { " ~
          "id: " ~ node.getId() ~
        " }"
      );
    }
  }

  /**
   *
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