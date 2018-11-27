/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.io;

import std.stdio : File;
import std.string : strip;
import std.array : split;

import liberty.logger;

/**
 *
**/
final abstract class TextIO {
  /**
   *
  **/
  static void loadFont(string path) {
    import std.array : split;

    // Check extension
    string[] splitArray = path.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "fnt":
        return loadFNTFile(path);
      default:
        Logger.error(	
          "File format not supported for font data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
  }

  private static void loadFNTFile(string path) {
    // Open the file
    auto file = File(path);
    scope(exit) file.close();

    // Read the file and build text data
    auto range = file.byLine();
    foreach (line; range) {
      line = line.strip();
      char[][] tokens = line.split(" ");

    }
  }
}