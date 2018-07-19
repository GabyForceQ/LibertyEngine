/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module liberty.audio.engine;

import liberty.core.utils : Singleton;
import liberty.core.logger : Logger, ManagerBody;

/**
 * A failing Audio function should <b>always</b> throw a $(D AudioEngineException).
 */
final class AudioEngineException : Exception {
	
    /**
     * Exception constructor.
     * It prints the message, the file and the line where the exception has been thrown as information.
     * Params:
     *      msg = exception message
     *      file = source file where the exception has been thrown
     *      line = line from the file where the exception has been thrown
     *      next = the next $(D, Throwable) callback
     */
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) @safe {
        super(msg, file, line, next);
        import std.conv : to;
        Logger.get.exception("Message: '" ~ msg ~ "'; File: '" ~ file ~ "'; Line:'" ~ line.to!string ~ "'.");
    }
}

/**
 * Singleton class used to manage audio.
 * It's a manager class so it implements $(D ManagerBody).
 */
final class AudioEngine : Singleton!AudioEngine {
	
    mixin(ManagerBody);

    private static {
        immutable startBody = q{};
        immutable stopBody = q{};
    }

}