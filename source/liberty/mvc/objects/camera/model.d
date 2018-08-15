module liberty.mvc.objects.camera.model;

import liberty.core.math.vector : Vector3F;
import liberty.core.math.matrix : Matrix4F;
import liberty.mvc.meta : Model;
import liberty.mvc.objects.camera.constants : CameraProjection;

/**
 *
**/
@Model
struct CameraModel {
  public {
    /**
     * Camera projection.
    **/
    Matrix4F projection;
    
    /**
     * Camera view.
    **/
    Matrix4F view;

    /**
     * Position attribute.
    **/
    Vector3F position;

    /**
     * Front attribute.
    **/
    Vector3F front;

    /**
     * Up attribute.
    **/
    Vector3F up;

    /**
     * Right attribute.
    **/
    Vector3F right;

    /**
     *  World up attribute.
    **/
    Vector3F worldUp;

    /**
     * Yaw Euler angle.
    **/
    float yaw;

    /**
     * Pitch Euler angle.
    **/
    float pitch;

    /**
     * Movement speed multiplier setting.
    **/
    float movementSpeedMultiplier = 100.0f;

    /**
     * Movement speed setting.
    **/
    float movementSpeed = 8.0f;

    /**
     * Mouse sensitivity setting.
    **/
    float mouseSensitivity = 0.1f;

    /**
     * Field of view setting.
    **/
    float fov = 45.0f;

    /**
     * Constrain pitch setting.
    **/
    bool constrainPitch = true;

    /**
     * Mouse is used first time.
    **/
    bool firstTimeMouse = true;

    /**
     * TODO: For Speed Multiplier
    **/
    bool scrollReversedOrder = true;

    /**
     *
    **/
    float lastX;

    /**
     *
    **/
    float lastY;

    /**
     * Near plane setting.
    **/
    float nearPlane = 0.1f;

    /**
     * Far plane setting.
    **/
    float farPlane = 1000.0f;

    /**
     * Camera projection type.
     * It can be Perspective for 3D view or Orthographic for 2D view.
    **/
    CameraProjection projectionType = CameraProjection.Perspective;
  }
}