/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/world/actor.d, _actor.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.world.actor;
import liberty.core.world.node: Node;
/// An actor has action mapping.
abstract class Actor : Node {
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
    }
}