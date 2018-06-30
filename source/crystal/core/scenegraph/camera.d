/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.scenegraph.camera;
import liberty.core.engine: CoreEngine;
import liberty.core.scenegraph.actor: Actor;
import liberty.core.scenegraph.node: Node;
import liberty.core.scenegraph.services: NodeServices, Constructor;
import liberty.core.input: Input, KeyCode, KeyModFlag, MouseButton;
import liberty.math.functions: radians, sin, cos;
import liberty.math.vector: Vector2I, Vector3F, cross;
import liberty.math.matrix: Matrix4F;
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
		Matrix4F _projection;
        Matrix4F _view;
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
	float fov() pure nothrow const {
		return _fov;
	}
	///
	float nearPlane() pure nothrow const {
		return _nearPlane;
	}
	///
	float farPlane() pure nothrow const {
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
        _lastX = CoreEngine.mainWindow.width / 2;
        _lastY = CoreEngine.mainWindow.height / 2;
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
	Matrix4F projectionMatrix() {
		Vector2I size = CoreEngine.mainWindow.size;
		final switch (_cameraProjection) with (CameraProjection) {
			case Perspective:
				return Matrix4F.perspective(radians(_fov), cast(float)size.x / size.y, _nearPlane, _farPlane);
			case Orthographic:
				return Matrix4F.orthographic(0, size.x, size.y, 0, _nearPlane, _farPlane);
		}
	}
	///
	Matrix4F viewMatrix() {
		return Matrix4F.lookAt(_position, _position + _front, _up);
	}
	///
	void fov(float value) {
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
							_fov += Input.mouseDeltaWheelY();
						} else {
							_fov -= Input.mouseDeltaWheelY();
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
				Input.windowGrab = true;
				Input.cursorVisible = false;
				if (Input.isMouseMoving()) {
					if (_firstMouse) {
						_lastX = Input.mousePosition.x;
						_lastY = Input.mousePosition.y;
						_firstMouse = false;
					}
					float xoffset = Input.mousePosition.x - _lastX;
					float yoffset = _lastY - Input.mousePosition.y;
					_lastX = Input.mousePosition.x;
					_lastY = Input.mousePosition.y;
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
				Input.windowGrab = false;
				Input.cursorVisible = true;
				_firstMouse = true;
			}
			_projection = projectionMatrix;
			_view = viewMatrix;
		}
	}
	///
	ref const(Matrix4F) projection() {
		return _projection;
	}
	///
	ref const(Matrix4F) view() {
		return _view;
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
    void yaw(float value) {
        _yaw = value;
    }
    ///
    void pitch(float value) {
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