/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/io/manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.io.manager;

import std.stdio : File;

import liberty.logger.impl;

/**
 * Used for managing files and console input/output.
**/
final class IOManager {
  @disable this();
  
  /**
   *
  **/
  static bool readFileToBuffer(string filePath, ref char[] buffer, string mode = "r") {
    // Try to open and read file
    auto file = File(filePath, mode);
    scope(exit) file.close();

    // Check file loaded successfully
    if (file.error()) {
      Logger.error("File couldn't be opened", typeof(this).stringof);
      return false;
    }
    
    // Get the file size
    ulong fileSize = file.size();

    // Reduce the file size by any header bytes that might be present
    fileSize -= file.tell();

    // Fill buffer
    buffer = file.rawRead(new char[cast(size_t)fileSize]);

    return true;
  }

  /**
   *
  **/
  unittest {
    char[] buf;

    if (!IOManager.readFileToBuffer("test_file.txt", buf))
      assert(0, "Operation failed!");

    assert(
      buf == "Hello,\r\nDear engine!" ||
      buf == "Hello,\nDear engine!", 
      "Buffer does not containt the same data as file"
    );
  }

  /**
   *
  **/
  //static bool writeBufferToFile(char[] buffer, string filePath) {
  //}
}