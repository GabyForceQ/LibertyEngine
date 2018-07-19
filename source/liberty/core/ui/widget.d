/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/widget.d, _widget.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.widget;

import liberty.core.world.node : Node;
import liberty.core.world.entity : Entity;
import liberty.core.ui.services : IListener;

/**
 * An Widget is a 2D element on the screen.
 * It doesn't depend by the world camera.
 */
abstract class Widget : Entity, IListener {

    private {
        void delegate() _onUpdate = null;
    }
    
    // TODO. Bug. This sould be private.   
    bool _canListen;

    /**
     *
     */
    this(string id, Node parent) {
        super(id, parent);
    }

    /**
     *
     */
    override void update(in float deltaTime) {
        if (_onUpdate !is null) {
			_onUpdate();
		}
    }

    /**
     *
     */
    void stopListening() {
        _canListen = false;
    }

    /**
     *
     */
    void onUpdate(void delegate() event) pure nothrow @property {
        _onUpdate = event;
    }
    
}