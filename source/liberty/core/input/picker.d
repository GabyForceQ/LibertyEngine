/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/picker.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.input.picker;

import liberty.core.input.impl : Input;
import liberty.core.math.vector : Vector2F, Vector3F, Vector4F;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.objects.camera.impl : Camera;
import liberty.core.objects.terrain.impl : Terrain;
import liberty.core.platform : Platform;
import liberty.core.window : Window;

/**
 *
**/
final class MousePicker {
  private {
    static const int recursionCount = 200;
    static const float rayRange = 600;

    Camera camera;
    Terrain terrain;
    Vector3F currentRay;
    Vector3F currentTerrainPoint;
  }
  
  /**
   *
  **/
  Vector3F getCurrentRay() pure nothrow {
    return currentRay;
  }

  /**
   *
  **/
  Vector3F getCurrentTerrainPoint() pure nothrow {
    return currentTerrainPoint;
  }

  /**
   *
  **/
  void update(Camera camera, Terrain terrain) {
    this.camera = camera;
    this.terrain = terrain;

    currentRay = computeMouseRay();

    if (intersectionInRange(0, rayRange, currentRay)) {
      currentTerrainPoint = binarySearch(0, 0, rayRange, currentRay);
      //currentTerrainPoint.y = 0; ///////
    }
    else
      currentTerrainPoint = Vector3F(float.nan, float.nan, float.nan);
  }

  private Vector3F computeMouseRay() {
    Vector2F normalizedCoords = getNormalizedDeviceCoords(Input.getMousePostion());
    Vector4F clipCoords = Vector4F(normalizedCoords.x , normalizedCoords.y, -1.0f, 1.0f);
    Vector4F eyeCoords = toEyeCoords(clipCoords);
    Vector3F worldRay = toWorldCoords(eyeCoords);

    static int oo = 0;
    if (oo == 40) {
      import liberty.engine;
      Logger.exception(worldRay.toString());
      oo = 0;
    }
    oo++;
    return worldRay;
  }

  private Vector3F toWorldCoords(Vector4F eyeCoords) {
    Matrix4F invView = camera.getViewMatrix().inverse();
    Vector4F rayWorld = Matrix4F.transformation(invView, eyeCoords);
    Vector3F mouseRay = Vector3F(rayWorld.x, rayWorld.y, rayWorld.z);
    mouseRay.normalize();

    return mouseRay;
  }

  private Vector4F toEyeCoords(Vector4F clipCoords) {
    Matrix4F invProjection = camera.getProjectionMatrix().inverse();
    Vector4F eyeCoords = Matrix4F.transformation(invProjection, clipCoords);

    return Vector4F(eyeCoords.x, eyeCoords.y, -1.0f, 0.0f);
  }

  private Vector2F getNormalizedDeviceCoords(Vector2F mousePos, Window window = Platform.getWindow()) {
    return Vector2F(
      (2.0f * mousePos.x) / window.getWidth() - 1.0f,
      -((2.0f * mousePos.y) / window.getHeight() - 1.0f)
    );
  }

  private Vector3F getPointOnRay(Vector3F ray, float distance) {
		return camera.getPosition() + ray * distance;
	}
	
	private Vector3F binarySearch(int count, float start, float finish, Vector3F ray) {
		const float half = start + ((finish - start) / 2.0f);

		if (count >= recursionCount)
			return getPointOnRay(ray, half);

		if (intersectionInRange(start, half, ray))
			return binarySearch(count + 1, start, half, ray);
		else
			return binarySearch(count + 1, half, finish, ray);
	}

	private bool intersectionInRange(float start, float finish, Vector3F ray) {
		Vector3F startPoint = getPointOnRay(ray, start);
		Vector3F endPoint = getPointOnRay(ray, finish);

		return !isUnderGround(startPoint) && isUnderGround(endPoint);
	}

	private bool isUnderGround(Vector3F testPoint) {
		float height = 0;

    height = terrain.getHeight(testPoint.x, testPoint.z);

		return testPoint.y < height;
	}
}