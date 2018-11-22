/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/logger/impl.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - Add 'current platform' on log message.
**/
module liberty.logger.impl;

import std.stdio : writeln, File;
import std.datetime.systime : SysTime, Clock;
import std.array : split;

import liberty.core.engine;
import liberty.logger.constants;

/**
 * Logger class is used for logging a message.
 * You can log a message to the system console or to a file: "logs.txt".
 * You can change the log file name.
 * You can activate or deactivate logger any time.
**/
final abstract class Logger {
  private {
    static File logFile;
    
    version (Win32)
      static string platformName = " [Win_x86]";
    else version (Win64)
      static string platformName = " [Win_x64]";
  }

  /**
   *
  **/
  static void initialize() {
    logFile = File(logFileName, "a");
  }

  /**
   *
  **/
  static void deinitialize() {
    logFile.close();
  }
  
  /**
   * Set false if you don't want logger to run.
  **/
  static bool isActive = true;
  
  /**
   * Log file name.
  **/
  static string logFileName = "logs.txt";

  /**
   * Log an information message. 
   * It starts with the current time + " -> LOG_INFO: "
   * Params:
   *      message = the information message
   *      obj = current class reference, mostly you pass 'this'
  **/
  static void info(string message, string objectName, bool onlyToConsole = false) {
    log(LogType.Info, objectName ~ " -> " ~ message, onlyToConsole);
  }
  
  /**
   * Log a warning message. 
   * It starts with the current time + " -> LOG_WARNING: "
   * Params:
   *      message = the warning message
   *      obj = current class reference, mostly you pass 'this'
  **/
  static void warning(string message, string objectName, bool onlyToConsole = false) {
    log(LogType.Warning, objectName ~ " -> " ~ message, onlyToConsole);
  }

  /**
   * Log an error message.
   * The type of the error is fatal so the program will exit with a status code of 1.
   * It starts with the current time + " -> LOG_ERROR: "
   * Params:
   *      message = the error message
   *      obj = current class reference, mostly you pass 'this'
  **/
  static void error(string message, string objectName, bool onlyToConsole = false) {
    log(LogType.Error, objectName ~ " -> " ~ message, onlyToConsole);
    version (unittest) {}
    else
      CoreEngine.forceShutDown(true);
  }

  /**
   * Log an exception message. 
   * It starts with the current time + " -> LOG_EXCEPTION: "
   * Params:
   *      message = the exception message
  **/
  static void exception(string message, bool onlyToConsole = false) {
    log(LogType.Exception, message, onlyToConsole);
  }

  /**
   * Log a debug information message. 
   * It starts with the current time + " -> LOG_DEBUG: "
   * Only works in debug mode.
   * Params:
   *      message = the debug information message
   *      obj = current class reference, mostly you pass 'this'
  **/
  static void console(string message, string objectName, bool onlyToConsole = false) {
    log(LogType.Debug, objectName ~ " -> " ~ message, onlyToConsole);
  }

  /**
   * Log a todo message. 
   * It starts with the current time + " -> LOG_TODO: " 
   * Params:
   *      message = the todo message
   *      obj = current class reference, mostly you pass 'this'
  **/
  static void todo(string message, string objectName, bool onlyToConsole = false) {
    log(LogType.Todo, objectName ~ " -> " ~ message, onlyToConsole);
  }

  /**
   * Log a message using LogType.
  **/
  static void log(LogType type, string message, bool onlyToConsole = false) {
    if (isActive) {
      string currentTime = Clock.currTime().toString().split(".")[0] ~ platformName;
      final switch (type) with (LogType) {
        case Info:
          debug writeln(currentTime ~ " -> LOG_INFO: " ~ message);
          if (!onlyToConsole)
            logFile.writeln(currentTime ~ " -> LOG_INFO: " ~ message);
          break;
        case Warning:
          debug writeln(currentTime ~ " -> LOG_WARNING: " ~ message);
          if (!onlyToConsole)
            logFile.writeln(currentTime ~ " -> LOG_WARNING: " ~ message);
          break;
        case Error:
          debug writeln(currentTime ~ " -> LOG_ERROR: " ~ message);
          if (!onlyToConsole)
            logFile.writeln(currentTime ~ " -> LOG_ERROR: " ~ message);
          break;
        case Exception:
          debug writeln(currentTime ~ " -> LOG_EXCEPTION: " ~ message);
          if (!onlyToConsole)
            logFile.writeln(currentTime ~ " -> LOG_EXCEPTION: " ~ message);
          break;
        case Debug:
          debug writeln(currentTime ~ " -> LOG_DEBUG: " ~ message);
          if (!onlyToConsole)
            debug logFile.writeln(currentTime ~ " -> LOG_DEBUG: " ~ message);
          break;
        case Todo:
          debug writeln(currentTime ~ " -> LOG_TODO: " ~ message);
          if (!onlyToConsole)
            logFile.writeln(currentTime ~ " -> LOG_TODO: " ~ message);
          break;
      }
    }
  }
}

/**
 * Example for Logger usage:
**/
unittest {
  class LogClass {
    this() {
      Logger.initialize();
      scope(exit) Logger.deinitialize();
      Logger.console("Test message!", typeof(this).stringof);
      Logger.info("Info test message!", typeof(this).stringof);
      Logger.warning("Warning test message!", typeof(this).stringof);
      Logger.error("Error test message!", typeof(this).stringof);
      try {
        immutable int x = 5;
        if (x == 5)
          throw new Exception("x cannot be 5!");
      } catch (Exception e) {
        Logger.exception("Exception test message!");
      }
      Logger.todo("Todo test message!", typeof(this).stringof);
    }
  }

  new LogClass();
}