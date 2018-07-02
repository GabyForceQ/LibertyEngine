/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.ui.button;
import liberty.core.engine;
import liberty.core.scenegraph;
import liberty.core.input : Input, MouseButton;
import liberty.math;
import liberty.graphics;
import liberty.ui.widget : Widget;
import std.string : splitLines;
import liberty.core.geometry.shapes;
///
final class Button : Widget {
	///
	mixin(NodeServices);
	///
    this(string id, Node parent, int x, int y, int width, int height) {
        this(id, parent);
        setPosition(x, y, width, height);
    }
	///
	this(string id, int x, int y, int width, int height) {
		this(id);
		setPosition(x, y, width, height);
	}
	~this() {
		//shader.cleanUp();
	}
	///
	int x = 0;
	///
	int y = 0;
	///
	int width = 0;
	///
	int height = 0;
    private {
        void delegate() _onLeftClick = null;
        //void delegate() _onDoubleClick = null;
        void delegate() _onMiddleClick = null;
        void delegate() _onRightClick = null;
        //void delegate() _onMousePress = null;
        //void delegate() _onMouseRelease = null
        //void delegate() _onMouseEnter = null;
        //void delegate() _onMouseLeave = null;
        void delegate() _onMouseMove = null;
        void delegate() _onMouseInside = null;
        void delegate() _onUpdate = null;
        void delegate() _onRender = null;
        bool _isOnLeftClick = false;
        bool _isOnMiddleClick = false;
        bool _isOnRightClick = false;
        bool _isOnMouseMove = false;
        bool _isOnMouseInside = false;
        Vector2I _mousePos;
        Vector2I _oldMousePos;
    }
	///
	void setPosition(int x, int y, int width, int height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	///
	void position(Vector4I position) pure nothrow @safe @nogc @property {
		this.x = position.x;
		this.y = position.y;
		this.width = position.z;
		this.height = position.w;
	}
	///
	override void update(float deltaTime) {
		if (_canListen) {
			clearAllIsOnEvents();
			if (mouseIntersectsThis()) {
				//if (hasOnMouseEnter()) {}
				if (hasOnMouseMove() && _oldMousePos != _mousePos) {
                    _onMouseMove();
                    _isOnMouseMove = true;
				}
				if (hasOnMouseInside()) {
					_onMouseInside();
					_isOnMouseInside = true;
				}
				if (hasOnLeftClick()) {
	                if (Input.get.isMouseButtonPressed(MouseButton.Left)) {
                        _onLeftClick();
                        _isOnLeftClick = true;
	                }
				}
				if (hasOnMiddleClick()) {
                    if (Input.get.isMouseButtonPressed(MouseButton.Middle)) {
                        _onMiddleClick();
                        _isOnMiddleClick = true;
                    }
                }
                if (hasOnRightClick()) {
                    if (Input.get.isMouseButtonPressed(MouseButton.Right)) {
                        _onRightClick();
                        _isOnRightClick = true;
                    }
                }
			} else {
				//if (hasOnMouseLeave() && oldMouseIntersectsThis()) {

				//}
			}
			_oldMousePos = _mousePos;
		}
		if (_onUpdate !is null) {
			_onUpdate();
		}
	}
	///
    void onLeftClick(void delegate() event) pure nothrow @property {
        _onLeftClick = event;
    }
    ///
    void onMiddleClick(void delegate() event) pure nothrow @property {
        _onMiddleClick = event;
    }
    ///
    void onRightClick(void delegate() event) pure nothrow @property {
        _onRightClick = event;
    }
    ///
	void onMouseMove(void delegate() event) pure nothrow @property {
		_onMouseMove = event;
	}
	///
    void onMouseInside(void delegate() event) pure nothrow @property {
        _onMouseInside = event;
    }
    ///
    void onUpdate(void delegate() event) pure nothrow @property {
        _onUpdate = event;
    }
    ///
    void onRender(void delegate() event) pure nothrow @property {
        _onRender = event;
    }
	///
	bool hasOnLeftClick() pure nothrow const {
		if (_onLeftClick !is null) {
			return true;
		}
		return false;
	}
	///
	bool hasOnMiddleClick() pure nothrow const {
        if (_onMiddleClick !is null) {
            return true;
        }
        return false;
    }
    ///
    bool hasOnRightClick() pure nothrow const {
        if (_onRightClick !is null) {
            return true;
        }
        return false;
    }
	///
	bool hasOnMouseMove() pure nothrow const {
        if (_onMouseMove !is null) {
            return true;
        }
        return false;
    }
    ///
    bool hasOnMouseInside() pure nothrow const {
        if (_onMouseInside !is null) {
            return true;
        }
        return false;
    }
	///
    bool isOnLeftClick() pure nothrow const {
        return _isOnLeftClick;
    }
    ///
    bool isOnMiddleClick() pure nothrow const {
        return _isOnMiddleClick;
    }
    ///
    bool isOnRightClick() pure nothrow const {
        return _isOnRightClick;
    }
    ///
    bool isOnMouseMove() pure nothrow const {
        return _isOnMouseMove;
    }
    ///
    bool isOnMouseInside() pure nothrow const {
        return _isOnMouseInside;
    }
	///
	int getNumberOfEvents() pure nothrow {
		int events = 0;
		if (hasOnLeftClick()) events++;
		if (hasOnMiddleClick()) events++;
        if (hasOnRightClick()) events++;
		if (hasOnMouseMove()) events++;
		if (hasOnMouseInside()) events++;
		return events;
	}
	private void clearAllIsOnEvents() {
        _isOnLeftClick = false;
        _isOnMiddleClick = false;
        _isOnRightClick = false;
        _isOnMouseMove = false;
        _isOnMouseInside = false;
    }
    private void clearAllEvents() {
        _onLeftClick = null;
        _onMiddleClick = null;
        _onRightClick = null;
        _onMouseMove = null;
        _onMouseInside = null;
    }
    private bool mouseIntersectsThis() {
    	_mousePos = Input.get.mousePosition;
    	return _mousePos.x > x && _mousePos.x < x + width && _mousePos.y > y && _mousePos.y < y + height;
    }
    private bool oldMouseIntersectsThis() {
        return _oldMousePos.x > x && _oldMousePos.x < x + width && _oldMousePos.y > y && _oldMousePos.y < y + height;
    }
    ///
    override void stopListening() {
        __canListen = false;
        clearAllIsOnEvents();
        clearAllEvents();
    }
}