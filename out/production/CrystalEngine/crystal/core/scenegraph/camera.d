/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.scenegraph.camera;
import crystal.core.engine: CoreEngine;
import crystal.core.scenegraph.actor: Actor;
import crystal.core.scenegraph.node: Node;
import crystal.core.scenegraph.services: NodeServices, Constructor;
import crystal.core.input: Input, KeyCode, KeyModFlag, MouseButton;
import crystal.math.functions: radians, sin, cos;
import crystal.math.vector: Vector2I, Vector3F, cross;
import crystal.math.matrix: Matrix4F;
///
enum CameraProjection: byte {
    /// For 3D and 2D views
    Perspective = 0x00,
    /// Only for 2D views
    Orthographic = 0x01
}
///
enum CameraMovement: byte {
	///
	Forward = 0x00,
	///
	Backward = 0x01,
	///
	Left = 0x02,
	///
	Right = 0x03
}
///
final class Camera : Actor {
	mixin(NodeServices);
	private {
		Matrix4F projection;
        Matrix4F view;
		// Attributes.
		Vector3F _position;
		Vector3F _front;
		Vector3F _up;
		Vector3F _right;
		Vector3F _worldUp;
		// Euler Angles.
		float _yaw;
		float _pitch;
		// Options.
		float _movementSpeedMultiplier = 100.0f;
		float _movementSpeed = 8.0f;
		float _mouseSensitivity = 0.1f;
		float _fov = 45.0f;
		bool _constrainPitch = true;
		bool _firstMouse = true;
		bool _scrollReversedOrder = true; // TODO: For Speed Multiplier.
		float _lastX;
		float _lastY;
		float _nearPlane = 0.1f;
		float _farPlane = 1000.0f;
		CameraProjection _cameraProjection = CameraProjection.Perspective;
	}
	///
	enum Yaw = -90.0f;
	///
	enum Pitch = 0.0f;
	///
	float getFov() pure nothrow const {
		return _fov;
	}
	///
	float getNearPlane() pure nothrow const {
		return _nearPlane;
	}
	///
	float getFarPlane() pure nothrow const {
		return _farPlane;
	}
	///
	@Constructor private void _(){
		_front = Vector3F.backward;
        _position = Vector3F.zero;
        _worldUp = Vector3F.up;
        _yaw = Yaw;
        _pitch = Pitch;
        updateCameraVectors();
        _lastX = CoreEngine.getMainWindow().getWidth() / 2;
        _lastY = CoreEngine.getMainWindow().getHeight() / 2;
	}
	///
	this(string id, Node parent, Vector3F position = Vector3F.zero, Vector3F up = Vector3F.up, float yaw = Yaw, float pitch = Pitch) {
		super(id, parent);
	}
	///
	@property void position(Vector3F position) {
		_position = position;
	}
	///
	Matrix4F getProjectionMatrix() {
		Vector2I size = CoreEngine.getMainWindow().getSize();
		final switch (_cameraProjection) with (CameraProjection) {
			case Perspective:
				return Matrix4F.perspective(radians(_fov), cast(float)size.x / size.y, _nearPlane, _farPlane);
			case Orthographic:
				return Matrix4F.orthographic(0, size.x, size.y, 0, _nearPlane, _farPlane);
		}
	}
	///
	Matrix4F getViewMatrix() {
		return Matrix4F.lookAt(_position, _position + _front, _up);
	}
	///
	void setFov(float value) {
		_fov = value;
	}
	///
	void resetFov() {
		_fov = 45.0f;
	}
	///
	override void update(float deltaTime) {
		if (scene.activeCamera.id == id) {
			float velocity = _movementSpeed * deltaTime;
			// Process Mouse Scroll.
			if (Input.isMouseScrolling()) {
				if (Input.isKeyHold(KeyModFlag.LeftCtrl)) {
					if(_fov >= 1.0f && _fov <= 45.0f) {
						if (_scrollReversedOrder) {
							_fov += Input.getMouseDeltaWheelY();
						} else {
							_fov -= Input.getMouseDeltaWheelY();
						}
					}
					if(_fov <= 1.0f) {
						_fov = 1.0f;
					}
					if(_fov >= 45.0f) {
						_fov = 45.0f;
					}
				} else {
					velocity *= _movementSpeedMultiplier;
				}
			}
			// Process Keyboard.
			if (Input.isKeyHold(KeyCode.W)) {
				_position += _front * velocity;
			}
			if (Input.isKeyHold(KeyCode.S)) {
				_position -= _front * velocity;
			}
			if (Input.isKeyHold(KeyCode.A)) {
				_position -= _right * velocity;
			}
			if (Input.isKeyHold(KeyCode.D)) {
				_position += _right * velocity;
			}
			// Process Mouse Movement.
			if (Input.isMouseButtonPressed(MouseButton.Right)) {
				Input.setWindowGrab(true);
				Input.setCursorVisible(false);
				if (Input.isMouseMoving()) {
					if (_firstMouse) {
						_lastX = Input.getMousePosition().x;
						_lastY = Input.getMousePosition().y;
						_firstMouse = false;
					}
					float xoffset = Input.getMousePosition().x - _lastX;
					float yoffset = _lastY - Input.getMousePosition().y;
					_lastX = Input.getMousePosition().x;
					_lastY = Input.getMousePosition().y;
					xoffset *= _mouseSensitivity;
					yoffset *= _mouseSensitivity;
					_yaw   += xoffset;
					_pitch += yoffset;
					if (_constrainPitch) {
						if (_pitch > 89.0f) {
							_pitch =  89.0f;
						}
						if (_pitch < -89.0f) {
							_pitch = -89.0f;
						}
					}
					updateCameraVectors();
				}
			} else {
				Input.setWindowGrab(false);
				Input.setCursorVisible(true);
				_firstMouse = true;
			}
			projection = getProjectionMatrix();
			view = getViewMatrix();
		}
	}
	///
	ref const(Matrix4F) getProjection() {
		return projection;
	}
	///
	ref const(Matrix4F) getView() {
		return view;
	}
	///
	void rotateYaw(float value) {
		_yaw += value;
	}
	///
    void rotatePitch(float value) {
        _pitch += value;
    }
    ///
    void setYaw(float value) {
        _yaw = value;
    }
    ///
    void setPitch(float value) {
        _pitch = value;
    }
	///
	void switchProjectionType() {
		final switch (_cameraProjection) with (CameraProjection) {
			case Perspective:
				_cameraProjection = Orthographic;
				break;
			case Orthographic:
				_cameraProjection = Perspective;
				break;
		}
	}
	private void updateCameraVectors() {
		Vector3F front;
		front.x = cos(radians(_yaw)) * cos(radians(_pitch));
        front.y = sin(radians(_pitch));
        front.z = sin(radians(_yaw)) * cos(radians(_pitch));
        _front = front.normalized();
        _right = _front.cross(_worldUp);
        _right.normalize();
        _up = _right.cross(_front);
        _up.normalize();
	}
}