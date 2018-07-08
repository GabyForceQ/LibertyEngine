/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/ui/button.d, _button.d)
 * Documentation:
 * Coverage:
 */
module liberty.ui.button;
import liberty.core.engine : CoreEngine;
import liberty.core.world.node : Node;
import liberty.core.world.services : NodeServices, Constructor;
import liberty.core.input : Input, MouseButton;
import liberty.math.vector : Vector2I;
import liberty.math.shapes : RectI;
import liberty.ui.widget : Widget;
import liberty.core.geometry.shapes;
///
final class Button : Widget {
	///
	mixin(NodeServices);
	///
	enum MouseLeftClick = "MouseLeftClick";
	///
	enum MouseMiddleClick = "MouseMiddleClick";
	///
	enum MouseRightClick = "MouseRightClick";
	///
	enum MouseMove = "MouseMove";
	///
	enum MouseInside = "MouseInside";
    ///
    RectI shape;
    private {
        void delegate() _onMouseLeftClick = null;
        void delegate() _onMouseMiddleClick = null;
        void delegate() _onMouseRightClick = null;
        void delegate() _onMouseMove = null;
        void delegate() _onMouseInside = null;
        bool _isOnMouseLeftClick;
        bool _isOnMouseMiddleClick;
        bool _isOnMouseRightClick;
        bool _isOnMouseMove;
        bool _isOnMouseInside;
        Vector2I _mousePos;
        Vector2I _oldMousePos;
    }
	///
    this(string id, Node parent, RectI shape = RectI.defaultData) {
        this(id, parent);
        this.shape = shape;
    }
	~this() {
		//shader.cleanUp();
	}
    /// Stops listener service.
    override void stopListening() {
        super.stopListening();
        clearAllIsOnEvents();
        clearAllEvents();
    }
	/// Button update function. It calls the widget update function which implements IUpdatable.
	override void update(in float deltaTime) {
        super.update(deltaTime);
		if (_canListen) {
			clearAllIsOnEvents();
			if (mouseIntersectsThis()) {
				if (hasOnMouseMove() && _oldMousePos != _mousePos) {
                    _onMouseMove();
                    _isOnMouseMove = true;
				}
				if (hasOnMouseInside()) {
					_onMouseInside();
					_isOnMouseInside = true;
				}
				if (hasOnMouseLeftClick()) {
	                if (Input.get.isMouseButtonPressed(MouseButton.Left)) {
                        _onMouseLeftClick();
                        _isOnMouseLeftClick = true;
	                }
				}
				if (hasOnMouseMiddleClick()) {
                    if (Input.get.isMouseButtonPressed(MouseButton.Middle)) {
                        _onMouseMiddleClick();
                        _isOnMouseMiddleClick = true;
                    }
                }
                if (hasOnMouseRightClick()) {
                    if (Input.get.isMouseButtonPressed(MouseButton.Right)) {
                        _onMouseRightClick();
                        _isOnMouseRightClick = true;
                    }
                }
			}
			_oldMousePos = _mousePos;
		}
	}
	/// Sets the MouseLeftClick event.
    void onMouseLeftClick(void delegate() event) pure nothrow @property {
        _onMouseLeftClick = event;
    }
    /// Sets the MouseMiddleClick event.
    void onMouseMiddleClick(void delegate() event) pure nothrow @property {
        _onMouseMiddleClick = event;
    }
    /// Sets the MouseRightClick event.
    void onMouseRightClick(void delegate() event) pure nothrow @property {
        _onMouseRightClick = event;
    }
    /// Sets the MouseMove event.
	void onMouseMove(void delegate() event) pure nothrow @property {
		_onMouseMove = event;
	}
	/// Sets the MouseInside event.
    void onMouseInside(void delegate() event) pure nothrow @property {
        _onMouseInside = event;
    }
	/// Returns true if event Button.MouseLeftClick is defined.
	bool hasOnMouseLeftClick() pure nothrow const {
		if (_onMouseLeftClick !is null) {
			return true;
		}
		return false;
	}
	/// Returns true if event Button.MouseMiddleClick is defined.
	bool hasOnMouseMiddleClick() pure nothrow const {
        if (_onMouseMiddleClick !is null) {
            return true;
        }
        return false;
    }
    /// Returns true if event Button.MouseRightClick is defined.
    bool hasOnMouseRightClick() pure nothrow const {
        if (_onMouseRightClick !is null) {
            return true;
        }
        return false;
    }
	/// Returns true if event Button.MouseMove is defined.
	bool hasOnMouseMove() pure nothrow const {
        if (_onMouseMove !is null) {
            return true;
        }
        return false;
    }
    /// Returns true if event Button.MouseInside is defined.
    bool hasOnMouseInside() pure nothrow const {
        if (_onMouseInside !is null) {
            return true;
        }
        return false;
    }
	/// Returns true if mouse left button is just pressed.
    bool isOnMouseLeftClick() pure nothrow const {
        return _isOnMouseLeftClick;
    }
    /// Returns true if mouse middle button is just pressed.
    bool isOnMouseMiddleClick() pure nothrow const {
        return _isOnMouseMiddleClick;
    }
    /// Returns true if mouse right button is just pressed.
    bool isOnMouseRightClick() pure nothrow const {
        return _isOnMouseRightClick;
    }
    /// Returns true if mouse is moving on the button surface.
    bool isOnMouseMove() pure nothrow const {
        return _isOnMouseMove;
    }
    /// Returns true if mouse is on the button surface.
    bool isOnMouseInside() pure nothrow const {
        return _isOnMouseInside;
    }
	/// Returns number of button-only events.
	ubyte getNumberOfEvents() pure nothrow {
		ubyte events;
		if (hasOnMouseLeftClick()) events++;
		if (hasOnMouseMiddleClick()) events++;
        if (hasOnMouseRightClick()) events++;
		if (hasOnMouseMove()) events++;
		if (hasOnMouseInside()) events++;
		return events;
	}
	private void clearAllIsOnEvents() {
        _isOnMouseLeftClick = false;
        _isOnMouseMiddleClick = false;
        _isOnMouseRightClick = false;
        _isOnMouseMove = false;
        _isOnMouseInside = false;
    }
    private void clearAllEvents() {
        _onMouseLeftClick = null;
        _onMouseMiddleClick = null;
        _onMouseRightClick = null;
        _onMouseMove = null;
        _onMouseInside = null;
    }
    private bool mouseIntersectsThis() {
    	_mousePos = Input.get.mousePosition;
    	return _mousePos.x > shape.x && _mousePos.x < shape.x + shape.width 
            && _mousePos.y > shape.y && _mousePos.y < shape.y + shape.height;
    }
    private bool oldMouseIntersectsThis() {
        return _oldMousePos.x > shape.x && _oldMousePos.x < shape.x + shape.width 
            && _oldMousePos.y > shape.y && _oldMousePos.y < shape.y + shape.height;
    }
}