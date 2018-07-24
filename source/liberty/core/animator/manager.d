/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/animator/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.animator.manager;

import liberty.core.utils : Singleton;
import liberty.core.logger : ManagerBody;
import liberty.core.utils.meta : ExceptionConstructor;

/**
 * A failing Animator function should <b>always</b> throw a $(D AnimatorException).
 */
final class AnimatorException : Exception {
	
    mixin(ExceptionConstructor);

}

/**
 * Singleton class used to animate everything.
 * It's a manager class so it implements $(D ManagerBody).
 */
final class Animator : Singleton!Animator {
	
    mixin(ManagerBody);
    
}