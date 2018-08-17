/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/objects/camera/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.objects.camera.impl;

import liberty.core.math.functions : radians, sin, cos;
import liberty.core.math.vector : Vector2I, Vector3F, cross;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.system.platform : Platform;
import liberty.world.objects.node.impl : WorldObject;
import liberty.world.objects.camera.constants : Yaw, Pitch, CameraProjection;

/**
 *
**/
final class Camera : WorldObject {
  private {
    Matrix4F projection;  // Camera projection.
    Matrix4F view;        // Camera view.
    
    Vector3F position;  // Position attribute.
    Vector3F front;     // Front attribute.
    Vector3F up;        // Up attribute.
    Vector3F right;     // Right attribute.
    Vector3F worldUp;   // World up attribute.

    float yaw;    // Yaw Euler angle.
    float pitch;  // Pitch Euler angle.
    
    float fov = 45.0f;         // Field of view setting.
    float nearPlane = 0.1f;    // Near plane setting.
    float farPlane = 1000.0f;  // Far plane setting.
    
    float movementSpeedMultiplier = 100.0f;  // Movement speed multiplier setting.
    float movementSpeed = 8.0f;              // Movement speed setting.
    float mouseSensitivity = 0.1f;           // Mouse sensitivity setting.

    bool constrainPitch = true;       // Constrain pitch setting.
    bool firstTimeMouse = true;       // Mouse is used first time.
    bool scrollReversedOrder = true;  // TODO: For Speed Multiplier

    float lastX;
    float lastY;
 
    CameraProjection projectionType = CameraProjection.Perspective;  // Camera projection type.
  }

  private static immutable constructor = q{
    this.front = Vector3F.backward;
    this.position = Vector3F.zero;
    this.worldUp = Vector3F.up;
    this.yaw = Yaw;
    this.pitch = Pitch;
    updateCameraVectors();
    this.lastX = CoreEngine.self.mainWindow.width / 2;
    this.lastY = CoreEngine.self.mainWindow.height / 2;
  };

  /**
   *
  **/
	this(
    string id, 
    WorldObject parent, 
    Vector3F position = Vector3F.zero, 
    Vector3F up = Vector3F.up, 
		float yaw = Yaw, 
    float pitch = Pitch
  ) {
		super(id, parent);
	}

  /**
   * Returns the camera position in the world.
  **/
	ref const(Vector3F) getPosition() pure nothrow @safe {
		return this.position;
	}

  /**
   * Set the camera world position using x, y and z coordinates.
  **/
  void setPosition(float x, float y, float z) pure nothrow @safe {
		this.position = Vector3F(x, y, z);
	}

  /**
	 * Set the camera world position using a vector of coordinates.
  **/
	void setPosition(Vector3F position) pure nothrow @safe {
		this.position = position;
	}

  /**
   * Returns field of view.
  **/
	float getFov() pure nothrow const @safe {
		return this.fov;
	}
	
  /**
   * Set field of view.
  **/
  void setFov(float value) pure nothrow @safe {
		this.fov = value;
	}

  /**
   * Reset fov to the default value of 45.0f.
  **/
  void resetFov() pure nothrow @safe {
    this.fov = 45.0f;
  }

  /**
   * Returns near plane.
  **/
	float getNearPlane() pure nothrow const @safe {
		return this.nearPlane;
	}

  /**
   * Returns far plane.
  **/
  float getFarPlane() pure nothrow const @safe {
		return this.farPlane;
	}

  /**
   * Returns projection matrix.
   * It calls prespective/orthographic function from Matrix4F.
  **/
  Matrix4F getProjectionMatrixObject() {
    Vector2I size = Platform.self.getWindow().getSize();

		final switch (this.projectionType) with (CameraProjection) {
			case Perspective:
				return Matrix4F.perspective(
          radians(this.fov), 
          cast(float)size.x / size.y, 
          this.nearPlane, 
          this.farPlane
        );

			case Orthographic:
				return Matrix4F.orthographic(
          0, 
          size.x, 
          size.y, 
          0, 
          this.nearPlane,
          this.farPlane
        );
		}
  }

  /**
   * Returns view matrix object.
   * It calls lookAt function from Matrix4F.
  **/
  Matrix4F getViewMatrixObject() {
		return Matrix4F.lookAt(
      this.position,
      this.position + this.front,
      this.up
    );
	}

  /**
   * Returns projection matrix.
  **/
  ref const(Matrix4F) getProjection() pure nothrow @safe {
		return this.projection;
	}

  /**
   * Returns view matrix.
  **/
  ref const(Matrix4F) getView() pure nothrow @safe {
		return this.view;
	}

  /**
   *
  **/
  void getYaw(float yaw) pure nothrow @safe {
      this.yaw = yaw;
  }

  /**
   *
  **/
  void getPitch(float pitch) pure nothrow @safe {
      this.pitch = pitch;
  }

  /**
   * Rotate yaw.
  **/
	void rotateYaw(float yaw) pure nothrow @safe {
		this.yaw += yaw;
	}

  /**
   * Rotate pitch.
  **/
  void rotatePitch(float pitch) pure nothrow @safe {
    this.pitch += pitch;
  }

  /**
   * Switch projection type from perspective to orthographic or vice versa.
  **/
	void switchProjectionType() pure nothrow @safe {
		final switch (this.projectionType) with (CameraProjection) {
			case Perspective:
				this.projectionType = Orthographic;
				break;
			case Orthographic:
				this.projectionType = Perspective;
				break;
		}
	}

  ///
	override void update(in float deltaTime) {
		//if (scene.activeCamera.id == id) {
			//float velocity = this.movementSpeed * deltaTime;

			// Process Mouse Scroll.
			//if (Input.self.isMouseScrolling()) {
			//	if (Input.self.isKeyHold(KeyModFlag.LeftCtrl)) {
			//		if(this.fov >= 1.0f && this.fov <= 45.0f) {
			//			if (this.scrollReversedOrder) {
			//				this.fov += Input.self.mouseDeltaWheelY();
			//			} else {
			//				this.fov -= Input.self.mouseDeltaWheelY();
			//			}
			//		}
			//		if(this.fov <= 1.0f) {
			//			this.fov = 1.0f;
			//		}
			//		if(this.fov >= 45.0f) {
			//			this.fov = 45.0f;
			//		}
			//	} else {
			//		velocity *= this.movementSpeedMultiplier;
			//	}
			//}

			// Process Keyboard.
			//if (InputNova.self.isKeyHold(KeyCode.W)) {
			//	this.position += this.front * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.S)) {
			//	this.position -= this.front * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.A)) {
			//	this.position -= this.right * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.D)) {
			//	this.position += this.right * velocity;
			//}

			// Process Mouse Movement.
			//if (Input.self.isMouseButtonPressed(MouseButton.Right)) {
			//	Input.self.windowGrab = true;
			//	Input.self.cursorVisible = false;
			//	if (Input.self.isMouseMoving()) {
			//		if (this.firstMouse) {
			//			this.lastX = Input.self.mousePosition.x;
			//			this.lastY = Input.self.mousePosition.y;
			//			this.firstMouse = false;
			//		}
			//		float xoffset = Input.self.mousePosition.x - this.lastX;
			//		float yoffset = this.lastY - Input.self.mousePosition.y;
			//		this.lastX = Input.self.mousePosition.x;
			//		this.lastY = Input.self.mousePosition.y;
			//		xoffset *= this.mouseSensitivity;
			//		yoffset *= this.mouseSensitivity;
			//		this.yaw   += xoffset;
			//		this.pitch += yoffset;
			//		if (this.constrainPitch) {
			//			if (this.pitch > 89.0f) {
			//				this.pitch =  89.0f;
			//			}
			//			if (this.pitch < -89.0f) {
			//				this.pitch = -89.0f;
			//			}
			//		}
			//		updateCameraVectors();
			//	}
			//} else {
			//	Input.self.windowGrab = false;
			//	Input.self.cursorVisible = true;
			//	this.firstMouse = true;
			//}
			//this.projection = projectionMatrixObject;
			//this.view = viewMatrixObject;
		//}
	}

	private void updateCameraVectors() {
		Vector3F front;
		front.x = cos(radians(this.yaw)) * cos(radians(this.pitch));
    front.y = sin(radians(this.pitch));
    front.z = sin(radians(this.yaw)) * cos(radians(this.pitch));
    this.front = front.normalized();
    this.right = this.front.cross(this.worldUp);
    this.right.normalize();
    this.up = this.right.cross(this.front);
    this.up.normalize();
	}
}