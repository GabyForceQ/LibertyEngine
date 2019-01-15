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
final abstract class IOManager {  
  /**
   *
  **/
  static bool readFileToBuffer(string filePath, ref char[] buffer, string mode = "r")
  in (mode == "r" || mode == "rb")
  do {
    // Try to open and read file
    auto file = File(filePath, mode);
    scope(exit) file.close;

    // Check file load
    if (file.error) {
      Logger.error("File couldn't be opened", typeof(this).stringof);
      return false;
    }
    
    // Get the file size
    ulong fileSize = file.size;

    // Reduce the file size by any header bytes that might be present
    fileSize -= file.tell;

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
      assert(0, "Operation failed at reading!");

    assert(
      buf == "Hello,\r\nDear engine!" ||
      buf == "Hello,\nDear engine!", 
      "Buffer does not containt the same data as file"
    );
  }

  /**
   *
  **/
  static bool writeBufferToFile(string filePath, ref char[] buffer, string mode = "w")
  in (mode == "w" || mode == "wb")
  do {
    // Try to open a file in write mode
    auto file = File(filePath, mode);
    scope(exit) file.close;

    // Check file load
    if (file.error) {
      Logger.error("File couldn't be created/opened", typeof(this).stringof);
      return false;
    }

    // Write to file
    file.write(buffer);

    return true;
  }

  /**
   *
  **/
  unittest {
    char[] buf = ['H', 'E', 'L', 'L', 'O', '7', '!'];
    char[] buf2;

    if (!IOManager.writeBufferToFile("test_write_file.txt", buf))
      assert(0, "Operation failed at writing!");

    if (!IOManager.readFileToBuffer("test_write_file.txt", buf2))
      assert(0, "Operation failed at reading!");

    assert(
      buf == buf2,
      "Buffer2 does not containt the same data as Buffer1"
    );
  }
}