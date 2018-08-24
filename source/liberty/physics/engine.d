/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.engine;

import liberty.core.utils : Singleton;
import liberty.core.manager.meta : ManagerBody;

/**
 * Singleton class used to handle 2D/3D physics.
 * It's a manager class so it implements $(D ManagerBody).
**/
final class PhysicsEngine : Singleton!PhysicsEngine {
  mixin(ManagerBody);
}