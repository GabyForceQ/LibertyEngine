/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/loader.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.loader;

import std.stdio : File;
import std.string : strip;
import std.array : split;

/**
 *
**/
final class FontLoader {
  @disable this();

  /**
   *
  **/
  static void loadFNTFile(string path) {
    // Open the file
    auto file = File(path);
    scope (exit) file.close();

    // Read the file and build font data
    auto range = file.byLine();
    foreach (line; range) {
      line = line.strip();
      char[][] tokens = line.split(" ");

    }
  }
}