/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/objects/camera/controller.d, _controller.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.objects.camera.controller;

import liberty.core.math.functions : radians, sin, cos;
import liberty.core.math.vector : Vector2I, Vector3F, cross;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.system.platform : Platform;
import liberty.mvc.meta : Controller, BindModel, JSON;
import liberty.mvc.objects.camera.model : CameraModel;
import liberty.mvc.objects.camera.view : CameraView;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.objects.camera.constants : Yaw, Pitch, CameraProjection;

/**
 *
**/
@Controller
final class CameraController : NodeController {
  mixin(BindModel);

  private static immutable constructor = q{
    model.front = Vector3F.backward;
    model.position = Vector3F.zero;
    model.worldUp = Vector3F.up;
    model.yaw = Yaw;
    model.pitch = Pitch;
    updateCameraVectors();
    model.lastX = CoreEngine.self.mainWindow.width / 2;
    model.lastY = CoreEngine.self.mainWindow.height / 2;
  };

  /**
   *
  **/
	this(
    string id, 
    NodeController parent, 
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
		return model.position;
	}

  /**
   * Set the camera world position using x, y and z coordinates.
  **/
  void setPosition(float x, float y, float z) pure nothrow @safe {
		model.position = Vector3F(x, y, z);
	}

  /**
	 * Set the camera world position using a vector of coordinates.
  **/
	void setPosition(Vector3F position) pure nothrow @safe {
		model.position = position;
	}

  /**
   * Returns field of view.
  **/
	float getFov() pure nothrow const @safe {
		return model.fov;
	}
	
  /**
   * Set field of view.
  **/
  void setFov(float value) pure nothrow @safe {
		model.fov = value;
	}

  /**
   * Reset fov to the default value of 45.0f.
  **/
  void resetFov() pure nothrow @safe {
    model.fov = 45.0f;
  }

  /**
   * Returns near plane.
  **/
	float getNearPlane() pure nothrow const @safe {
		return model.nearPlane;
	}

  /**
   * Returns far plane.
  **/
  float getFarPlane() pure nothrow const @safe {
		return model.farPlane;
	}

  /**
   * Returns projection matrix.
   * It calls prespective/orthographic function from Matrix4F.
  **/
  Matrix4F getProjectionMatrixObject() {
    Vector2I size = Platform.self.getWindow().getSize();

		final switch (model.projectionType) with (CameraProjection) {
			case Perspective:
				return Matrix4F.perspective(
          radians(model.fov), 
          cast(float)size.x / size.y, 
          model.nearPlane, 
          model.farPlane
        );

			case Orthographic:
				return Matrix4F.orthographic(
          0, 
          size.x, 
          size.y, 
          0, 
          model.nearPlane,
          model.farPlane
        );
		}
  }

  /**
   * Returns view matrix object.
   * It calls lookAt function from Matrix4F.
  **/
  Matrix4F getViewMatrixObject() {
		return Matrix4F.lookAt(
      model.position,
      model.position + model.front,
      model.up
    );
	}

  /**
   * Returns projection matrix.
  **/
  ref const(Matrix4F) getProjection() pure nothrow @safe {
		return model.projection;
	}

  /**
   * Returns view matrix.
  **/
  ref const(Matrix4F) view() pure nothrow @safe {
		return model.view;
	}

  /**
   *
  **/
  void yaw(float value) pure nothrow @safe {
      model.yaw = value;
  }

  /**
   *
  **/
  void pitch(float value) pure nothrow @safe {
      model.pitch = value;
  }

  /**
   * Rotate yaw.
  **/
	void rotateYaw(float value) pure nothrow @safe {
		model.yaw += value;
	}

  /**
   * Rotate pitch.
  **/
  void rotatePitch(float value) pure nothrow @safe {
    model.pitch += value;
  }

  /**
   * Switch projection type from perspective to orthographic or vice versa.
  **/
	void switchProjectionType() pure nothrow @safe {
		final switch (model.projectionType) with (CameraProjection) {
			case Perspective:
				model.projectionType = Orthographic;
				break;
			case Orthographic:
				model.projectionType = Perspective;
				break;
		}
	}

  ///
	override void update(in float deltaTime) {
		//if (scene.activeCamera.id == id) {
			//float velocity = model.movementSpeed * deltaTime;

			// Process Mouse Scroll.
			//if (Input.self.isMouseScrolling()) {
			//	if (Input.self.isKeyHold(KeyModFlag.LeftCtrl)) {
			//		if(model.fov >= 1.0f && model.fov <= 45.0f) {
			//			if (model.scrollReversedOrder) {
			//				model.fov += Input.self.mouseDeltaWheelY();
			//			} else {
			//				model.fov -= Input.self.mouseDeltaWheelY();
			//			}
			//		}
			//		if(model.fov <= 1.0f) {
			//			model.fov = 1.0f;
			//		}
			//		if(model.fov >= 45.0f) {
			//			model.fov = 45.0f;
			//		}
			//	} else {
			//		velocity *= model.movementSpeedMultiplier;
			//	}
			//}

			// Process Keyboard.
			//if (InputNova.self.isKeyHold(KeyCode.W)) {
			//	model.position += model.front * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.S)) {
			//	model.position -= model.front * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.A)) {
			//	model.position -= model.right * velocity;
			//}
			//if (InputNova.self.isKeyHold(KeyCode.D)) {
			//	model.position += model.right * velocity;
			//}

			// Process Mouse Movement.
			//if (Input.self.isMouseButtonPressed(MouseButton.Right)) {
			//	Input.self.windowGrab = true;
			//	Input.self.cursorVisible = false;
			//	if (Input.self.isMouseMoving()) {
			//		if (model.firstMouse) {
			//			model.lastX = Input.self.mousePosition.x;
			//			model.lastY = Input.self.mousePosition.y;
			//			model.firstMouse = false;
			//		}
			//		float xoffset = Input.self.mousePosition.x - model.lastX;
			//		float yoffset = model.lastY - Input.self.mousePosition.y;
			//		model.lastX = Input.self.mousePosition.x;
			//		model.lastY = Input.self.mousePosition.y;
			//		xoffset *= model.mouseSensitivity;
			//		yoffset *= model.mouseSensitivity;
			//		model.yaw   += xoffset;
			//		model.pitch += yoffset;
			//		if (model.constrainPitch) {
			//			if (model.pitch > 89.0f) {
			//				model.pitch =  89.0f;
			//			}
			//			if (model.pitch < -89.0f) {
			//				model.pitch = -89.0f;
			//			}
			//		}
			//		updateCameraVectors();
			//	}
			//} else {
			//	Input.self.windowGrab = false;
			//	Input.self.cursorVisible = true;
			//	model.firstMouse = true;
			//}
			//model.projection = projectionMatrixObject;
			//model.view = viewMatrixObject;
		//}
	}

	private void updateCameraVectors() {
		Vector3F front;
		front.x = cos(radians(model.yaw)) * cos(radians(model.pitch));
    front.y = sin(radians(model.pitch));
    front.z = sin(radians(model.yaw)) * cos(radians(model.pitch));
    model.front = front.normalized();
    model.right = model.front.cross(model.worldUp);
    model.right.normalize();
    model.up = model.right.cross(model.front);
    model.up.normalize();
	}
}