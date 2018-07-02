/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/logger.d, _logger.d)
 * Documentation:
 * Coverage:
 */
 // TODO: Add current platform on log message.
module liberty.core.logger;
import liberty.core.utils : Singleton, IService;
/// All types of log that you can use when logging a message.
enum LogType : ubyte {
    /// Used to log an information message.
    Info = 0x00,
    /// Used to log a warning message.
    Warning = 0x01,
    /// Used to log an error message.
    Error = 0x02,
    /// Used to log an exception message.
    Exception = 0x03,
    /// Used to log a debug message. Only works in debug mode.
    Debug = 0x04,
    /// Used to log a todo message.
    Todo = 0x05
}
///
final class Logger : Singleton!Logger, IService {
    private bool _serviceRunning;
	/// Start Logger service.
    void startService() pure nothrow @safe @nogc {
        _serviceRunning = true;
    }
    /// Stop Logger service.
    void stopService() pure nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart Logger service.
    void restartService() pure nothrow @safe @nogc {
        stopService();
        startService();
    }
    /// Returns true if Logger service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
    /// Log an information message. It starts with the current time + " -> LOG_INFO: "
    void info(string message) @safe {
        log(LogType.Info, message);
    }
    /// Log a warning message. It starts with the current time + " -> LOG_WARNING: "
    void warning(string message) @safe {
        log(LogType.Warning, message);
    }
    /// Log an error message. It starts with the current time + " -> LOG_ERROR: "
    void error(string message) @safe {
        log(LogType.Error, message);
    }
    /// Log an exception message. It starts with the current time + " -> LOG_EXCEPTION: "
    void exception(string message) @safe {
        log(LogType.Exception, message);
    }
    /// Log a debug message. Only works in debug mode. It starts with the current time + " -> LOG_DEBUG: "
    void console(string message) @safe {
        log(LogType.Debug, message);
    }
    /// Log a todo message. It starts with the current time + " -> LOG_TODO: "
    void todo(string message) @safe {
        log(LogType.Todo, message);
    }
    private void log(LogType type, string message) @safe {
        import std.stdio : writeln, File;
        import std.datetime.systime : SysTime, Clock;
        SysTime st = Clock.currTime();
        auto file = File("logs.txt", "a");
        scope (exit) file.close();
        synchronized {
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
///
@safe unittest {
    Logger.get.startService();
    scope (exit) Logger.get.stopService();
    Logger.get.console("Test message!");
    Logger.get.info("Info test message!");
    Logger.get.warning("Warning test message!");
    Logger.get.error("Error test message!");
    try {
        immutable int x = 5;
        if (x == 5) {
            throw new Exception("x cannot be 5!");
        }
    } catch (Exception e) {
        Logger.get.exception("Exception test message!");
    }
    Logger.get.todo("Todo test message!");
}