/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/components/transform/package.d, _package.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.components.transform;

import liberty.core.math.vector : Vector3F;
import liberty.core.math.matrix : Matrix4F;

import liberty.core.math.functions;
import liberty.core.math.vector;

import liberty.world.objects.camera : Camera;

struct Transform {

  //private static Camera camera;
  //private static float zNear;
  //private static float zFar;
  //private static float width;
  //private static float height;
  //private static float fov;
//
  //void setCamera(Camera camera) {
  //  Transform.camera = camera;
  //}
//
  //Camera getCamera() {
  //  return Transform.camera;
  //}
//
  //void setProjection(
  //  float fov,
  //  float width,
  //  float height,
  //  float zNear,
  //  float zFar
  //) {
  //  Transform.fov = fov;
  //  Transform.width = width;
  //  Transform.height = height;
  //  Transform.zNear = zNear;
  //  Transform.zFar = zFar;
  //}

  private {
    float _rotationAngle = 0.0f;
    Vector3F _translation = Vector3F.zero;
    Vector3F _rotation = Vector3F.zero;
    Vector3F _scale = Vector3F.one;
    Matrix4F _modelMatrix = Matrix4F().identity();
  }

  Vector3F getTranslation() pure nothrow @safe {
    return _translation;
  }

  void setTranslation(Vector3F translation) pure nothrow @safe {
    _modelMatrix.translate(translation);
    _translation = translation;
  }

  void setTranslation(float x, float y, float z) pure nothrow @safe {
    _modelMatrix.translate(Vector3F(x, y, z));
    _translation = Vector3F(x, y, z);
  }

  Vector3F getRotation() pure nothrow @safe {
    return _rotation;
  }

  void setRotation(Vector3F rotation) pure nothrow @safe {
    _rotation = rotation;
  }

  void setRotation(float x, float y, float z) pure nothrow @safe {
    _rotation = Vector3F(x, y, z);
  }

  void setRotationAngle(float angle) pure nothrow @safe {
    _rotationAngle = angle;
  }

  float getRotationAngle() pure nothrow @safe {
    return _rotationAngle;
  }

  Vector3F getScale() pure nothrow @safe {
    return _scale;
  }

  void setScale(Vector3F scale) pure nothrow @safe {
    _scale = scale;
  }

  void setScale(float x, float y, float z) pure nothrow @safe {
    _scale = Vector3F(x, y, z);
  }

  //Matrix4F getTransformation() {
  //  // Initialize translation matrix
  //  Matrix4F translationMatrix = Matrix4F().translation(_translation);
  //  
  //  // Initialize rotation matrix
  //  Matrix4F rotationMatrix = Matrix4F().rotation(_rotationAngle, _rotation);
//
  //  // Initialize scaling matrix
  //  Matrix4F scalingMatrix = Matrix4F().scaling(_scale);
  //  
  //  return translationMatrix * rotationMatrix * scalingMatrix;
  //}
//
  //Matrix4F getProjection() {
  //  Matrix4F transformationMatrix = getTransformation();
  //  
  //  Matrix4F projectionMatrix = Matrix4F().perspective(
  //    Transform.fov,
  //    Transform.width / Transform.height,
  //    Transform.zNear,
  //    Transform.zFar
  //  );
//
  //  Matrix4F cameraRotation = Matrix4F.camera(
  //    camera.getForward(),
  //    camera.getUp()
  //  );
//
  //  Matrix4F cameraTranslation = Matrix4F.translation(
  //    Vector3F(-camera.getPosition().x, -camera.getPosition().y, -camera.getPosition().z)
  //  );
//
  //  return projectionMatrix * cameraRotation * cameraTranslation * transformationMatrix;
  //}

  /**
    *
    */
	ref const(Matrix4F) modelMatrix() pure nothrow const @safe @nogc {
		return _modelMatrix;
	}
}