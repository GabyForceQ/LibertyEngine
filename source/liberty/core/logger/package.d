/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/logger/package.d, _package.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - Add 'current platform' on log message.
 */
module liberty.core.logger;

public {
    import liberty.core.logger.constants;
}

import liberty.core.utils : Singleton;
import liberty.core.logger.meta;

pragma(inline, true) :

/**
 * Singleton class used for logging a message.
 * You can log a message to the system console or to a file: "logs.txt".
 * It's a manager class so it implements $(D ManagerBody).
 */
final class Logger : Singleton!Logger {

    mixin(ManagerBody);

    private static {
        immutable startBody = q{};
        immutable stopBody = q{};
    }

    /**
     * Log an information message. 
     * It starts with the current time + " -> LOG_INFO: "
     * Params:
     *      message = the information message
     *      obj = current class reference, mostly you pass 'this'
     */
    void info(string message, Object obj) @safe {
        log(LogType.Info, message ~ " <-> " ~ obj.stringof);
    }
    
    /**
     * Log a warning message. 
     * It starts with the current time + " -> LOG_WARNING: "
     * Params:
     *      message = the warning message
     *      obj = current class reference, mostly you pass 'this'
     */
    void warning(string message, Object obj) @safe {
        log(LogType.Warning, message ~ " <-> " ~ obj.stringof);
    }

    /**
     * Log an error message. 
     * It starts with the current time + " -> LOG_ERROR: "
     * Params:
     *      message = the error message
     *      obj = current class reference, mostly you pass 'this'
     */
    void error(string message, Object obj) @safe {
        log(LogType.Error, message ~ " <-> " ~ obj.stringof);
    }

    /**
     * Log an exception message. 
     * It starts with the current time + " -> LOG_EXCEPTION: "
     * Params:
     *      message = the exception message
     */
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
     */
    void console(string message, Object obj) @safe {
        log(LogType.Debug, message ~ " <-> " ~ obj.stringof);
    }

    /**
     * Log a todo message. 
     * It starts with the current time + " -> LOG_TODO: " 
     * Params:
     *      message = the todo message
     *      obj = current class reference, mostly you pass 'this'
     */
    void todo(string message, Object obj) @safe {
        log(LogType.Todo, message ~ " <-> " ~ obj.stringof);
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

/**
 * Example for Logger usage:
 */
@safe unittest {
    Logger.get.startService();
    scope (exit) Logger.get.stopService();
    Logger.get.console("Test message!", null);
    Logger.get.info("Info test message!", null);
    Logger.get.warning("Warning test message!", null);
    Logger.get.error("Error test message!", null);
    try {
        immutable int x = 5;
        if (x == 5) {
            throw new Exception("x cannot be 5!");
        }
    } catch (Exception e) {
        Logger.get.exception("Exception test message!");
    }
    Logger.get.todo("Todo test message!", null);
}
