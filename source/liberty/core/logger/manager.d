/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/logger/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - Add 'current platform' on log message.
**/
module liberty.core.logger.manager;

import liberty.core.logger.constants : LogType;
import liberty.core.manager.meta : ManagerBody;
import liberty.core.utils : Singleton;
import liberty.core.system.engine : CoreEngine;

pragma (inline, true) :

/**
 * Singleton class used for logging a message.
 * You can log a message to the system console or to a file: "logs.txt".
 * It's a manager class so it implements $(D ManagerBody).
**/
final class Logger : Singleton!Logger {
  mixin(ManagerBody);

  /**
   * Log an information message. 
   * It starts with the current time + " -> LOG_INFO: "
   * Params:
   *      message = the information message
   *      obj = current class reference, mostly you pass 'this'
  **/
  void info(string message, string objectName) @safe {
    log(LogType.Info, objectName ~ " -> " ~ message);
  }
  
  /**
   * Log a warning message. 
   * It starts with the current time + " -> LOG_WARNING: "
   * Params:
   *      message = the warning message
   *      obj = current class reference, mostly you pass 'this'
  **/
  void warning(string message, string objectName) @safe {
    log(LogType.Warning, objectName ~ " -> " ~ message);
  }

  /**
   * Log an error message.
   * The type of the error is fatal so the program will exit with a status code of 1.
   * It starts with the current time + " -> LOG_ERROR: "
   * Params:
   *      message = the error message
   *      obj = current class reference, mostly you pass 'this'
  **/
  void error(string message, string objectName) @safe {
    log(LogType.Error, objectName ~ " -> " ~ message);
    version (unittest) {
    } else {
      CoreEngine.self.forceShutDown(true);
    }
  }

  /**
   * Log an exception message. 
   * It starts with the current time + " -> LOG_EXCEPTION: "
   * Params:
   *      message = the exception message
  **/
  void exception(string message) @safe {
    log(LogType.Exception, message);
  }

  /**
   * Log a debug information message. 
   * It starts with the current time + " -> LOG_DEBUG: "
   * Only works in debug mode.
   * Params:
   *      message = the debug information message
   *      obj = current class reference, mostly you pass 'this'
  **/
  void console(string message, string objectName) @safe {
    log(LogType.Debug, objectName ~ " -> " ~ message);
  }

  /**
   * Log a todo message. 
   * It starts with the current time + " -> LOG_TODO: " 
   * Params:
   *      message = the todo message
   *      obj = current class reference, mostly you pass 'this'
  **/
  void todo(string message, string objectName) @safe {
    log(LogType.Todo, objectName ~ " -> " ~ message);
  }

  private void log(LogType type, string message) @safe {
    synchronized {
      import std.stdio : writeln, File;
      import std.datetime.systime : SysTime, Clock;
      SysTime st = Clock.currTime();
      auto file = File("logs.txt", "a");
      scope (success) file.close();
      if (_serviceRunning) {
        final switch (type) with (LogType) {
          case Info:
            file.writeln(st.toISOExtString() ~ " -> LOG_INFO: " ~ message);
            break;
          case Warning:
            file.writeln(st.toISOExtString() ~ " -> LOG_WARNING: " ~ message);
            break;
          case Error:
            file.writeln(st.toISOExtString() ~ " -> LOG_ERROR: " ~ message);
            break;
          case Exception:
            file.writeln(st.toISOExtString() ~ " -> LOG_EXCEPTION: " ~ message);
            break;
          case Debug:
            debug writeln(st.toISOExtString() ~ " -> LOG_DEBUG: " ~ message);
            debug file.writeln(st.toISOExtString() ~ " -> LOG_DEBUG: " ~ message);
            break;
          case Todo:
            file.writeln(st.toISOExtString() ~ " -> LOG_TODO: " ~ message);
            break;
        }
      }
    }
  }
}

/**
 * Example for Logger usage:
 */
unittest {
  class Class {
    this() {
      Logger.self.startService();
      Logger.self.console("Test message!", typeof(this).stringof);
      Logger.self.info("Info test message!", typeof(this).stringof);
      Logger.self.warning("Warning test message!", typeof(this).stringof);
      Logger.self.error("Error test message!", typeof(this).stringof); -> TODO
      try {
        immutable int x = 5;
        if (x == 5) {
          throw new Exception("x cannot be 5!");
        }
      } catch (Exception e) {
        Logger.self.exception("Exception test message!");
      }
      Logger.self.todo("Todo test message!", typeof(this).stringof);
    }

    ~this() {
      Logger.self.stopService();
    }
  }

  Class c = new Class();
  c.destroy();
  c = null;
}