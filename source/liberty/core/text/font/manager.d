/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/text/font/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.text.font.manager;

import liberty.core.utils : Singleton;
import liberty.core.logger : ManagerBody;
import liberty.core.utils.meta : ExceptionConstructor;

/**
 * A failing FontManager function should <b>always</b> throw a $(D FontManagerEngineException).
 */
final class FontManagerEngineException : Exception {

    mixin(ExceptionConstructor);

}

/**
 * Singleton class used to manipulate fonts.
 * It's a manager class so it implements $(D ManagerBody).
 */
final class FontManager : Singleton!FontManager {
	
    mixin(ManagerBody);

}