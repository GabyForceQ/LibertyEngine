module liberty.mvc.objects.camera.model;

import liberty.core.math.vector : vector3F;
import liberty.core.math.matrix : Matrix4F;

@Model
struct CameraModel {
  mixin(Serialize);

  public @Ignore {
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
    vector3F position;

    /**
     * Front attribute.
    **/
    vector3F front;

    /**
     * Up attribute.
    **/
    vector3F up;

    /**
     * Right attribute.
    **/
    vector3F right;

    /**
     *  World up attribute.
    **/
    vector3F worldUp;

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
    CameraProjection _cameraProjection = CameraProjection.Perspective;
  }
}