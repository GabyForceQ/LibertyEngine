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
import liberty.core.utils.meta : ExceptionConstructor;

/**
 * A failing Audio function should <b>always</b> throw a $(D AudioEngineException).
 */
final class AudioEngineException : Exception {

    mixin(ExceptionConstructor);

}

/**
 * Singleton class used to manage audio.
 * It's a manager class so it implements $(D ManagerBody).
 */
final class AudioEngine : Singleton!AudioEngine {
	
    mixin(ManagerBody);

}