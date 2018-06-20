/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.audio.engine;
/// A failing Audio function should <b>always</b> throw a $(D AudioEngineException).
final class AudioEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
		super(msg, file, line, next);
	}
}
///
class AudioEngine {
	static:
}