/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/transform.d)
 * Documentation:
 * Coverage:
**/
module liberty.math.transform;

import liberty.logger.impl;
import liberty.math.functions;
import liberty.math.vector;
import liberty.math.matrix;
import liberty.scene.component;
import liberty.scene.meta;
import liberty.scene.entity;
import liberty.framework.primitive.vertex;
import liberty.framework.terrain.vertex;
import liberty.framework.gui.widget;
import liberty.core.platform;

/**
 *
**/
final class Transform : IComponent {
  private {
    // getParent
    Entity parent;
    Matrix4F modelMatrix = Matrix4F.identity();
    Matrix4F tempModelMatrix = Matrix4F.identity();
    
    Vector3F location = Vector3F.zero;
    Vector3F rotation = Vector3F.zero;
    Vector3F scale = Vector3F.one;

    Vector3F pivot = Vector3F.zero;
  }

  /**
   *
  **/
  this(Entity parent) pure nothrow {
    this.parent = parent;
  }

  /**
   *
  **/
  this(Entity parent, Transform transform) {
    this(parent);
    location = transform.location;

    tempModelMatrix.c[0][3] += location.x;
    tempModelMatrix.c[1][3] += location.y;
    tempModelMatrix.c[2][3] += location.z;

    updateModelMatrix();
  }

  /**
   * Translate location using x, y and z scalars as coordinates.
   * Location is done in  space.
  **/
	Transform setLocation(string op = "=")(float x, float y, float z)
  if (op == "=" || op == "+=" || op == "-=")
  do {
		return setLocation!(op)(Vector3F(x, y, z));
	}

  /**
   * Translate location using a vector with x, y and z coordinates.
   * Location is done in  space.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setLocation(string op = "=")(Vector3F location)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    static if (op == "=") {
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " this.location.x + location.x;");
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " this.location.y + location.y;");
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " this.location.z + location.z;");
    } else {
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " location.x;");
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " location.y;");
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " location.z;");
    }
    mixin("this.location " ~ op ~ " location;");

    updateModelMatrix;
		return this;
	}

  /**
   * Translate x-coordinate location.
   * Location is done in  space.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setLocationX(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    static if (op == "=")
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " location.x + value;");
    else
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " value;");
    mixin("location.x " ~ op ~ " value;");

    updateModelMatrix;
    return this;
	}
  
  /**
   * Translate y-coordinate location.
   * Location is done in  space.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setLocationY(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    static if (op == "=")
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " location.y + value;");
    else
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " value;");
    mixin("location.y " ~ op ~ " value;");

    updateModelMatrix;
    return this;
	}
  
  /**
   * Translate z-coordinate location.
   * Location is done in  space.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setLocationZ(string op = "=")(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    static if (op == "=")
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " location.z + value;");
    else
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " value;");
    mixin("location.z " ~ op ~ " value;");

    updateModelMatrix;
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle and rotation coordinates using scalars x, y and z.
   * Returns reference to this so it can be used in a stream.
  **/
	//Transform setRotation(string op = "=")(float angle, float rotX, float rotY, float rotZ) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {
	//	return setRotation!op(angle, Vector3F(rotX, rotY, rotZ));
	//}
  
  /**
   * Rotate object specifying the rotation angle and a vector of three scalars for x, y and z.
   * Returns reference to this so it can be used in a stream.
  **/
	//Transform setRotation(string op = "=")(float angle, Vector3F rotation) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {  
  //  return this;
	//}

  /*Transform setRotation(string op = "=")(Matrix3F rotation) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("tempModelMatrix.c[0][0] " ~ op ~ " rotation.c[0][0];");
    mixin("tempModelMatrix.c[0][1] " ~ op ~ " rotation.c[0][1];");
    mixin("tempModelMatrix.c[0][2] " ~ op ~ " rotation.c[0][2];");
    mixin("tempModelMatrix.c[1][0] " ~ op ~ " rotation.c[1][0];");
    mixin("tempModelMatrix.c[1][1] " ~ op ~ " rotation.c[1][1];");
    mixin("tempModelMatrix.c[1][2] " ~ op ~ " rotation.c[1][2];");
    mixin("tempModelMatrix.c[2][0] " ~ op ~ " rotation.c[2][0];");
    mixin("tempModelMatrix.c[2][1] " ~ op ~ " rotation.c[2][1];");
    mixin("tempModelMatrix.c[2][2] " ~ op ~ " rotation.c[2][2];");
    updateModelMatrix();
    return this;
	}*/
  
  /**
   * Rotate object specifying the rotation angle for pitch axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform rotatePitch(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("rotation.x " ~ op ~ " angle;");
		tempModelMatrix.rotateX(rotation.x.radians);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for yaw axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform rotateYaw(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("rotation.y " ~ op ~ " angle;");
		tempModelMatrix.rotateY(rotation.y.radians);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for roll axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform rotateRoll(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("rotation.z " ~ op ~ " angle;");
		tempModelMatrix.rotateZ(rotation.z.radians);

    updateModelMatrix();
    return this;
	}

  /**
   * Scale object using same value for x, y and z coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScale(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setScale!op(Vector3F(value, value, value));
	}
  
  /**
   * Scale object using x, y and z scalars for coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScale(string op = "=")(float x, float y, float z) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setScale!op(Vector3F(x, y, z));
	}
  
  /**
   * Scale object using a vector with x, y and z scalars for coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScale(string op = "=")(Vector3F scale) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " scale.x;");
    mixin("tempModelMatrix.c[1][1] " ~ op ~ " scale.y;");
    mixin("tempModelMatrix.c[2][2] " ~ op ~ " scale.z;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on x axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScaleX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on y axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScaleY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[1][1] " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on z axis.
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setScaleZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[2][2] " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * Returns object location in relative space.
  **/
	ref const(Vector3F) getLocation() pure nothrow const {
		return location;
	}
  
  /**
   * Returns object rotation in relative space.
  **/
	ref const(Vector3F) getRotation() pure nothrow const {
		return rotation;
	}
  
  /**
   * Returns object scale in relative space.
  **/
	ref const(Vector3F) getScale() pure nothrow const {
		return scale;
	}

  /**
   *
  **/
  Transform setPivot(string op = "=")(float x, float y, float z) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setPivot!op(Vector3F(x, y, z));
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  Transform setPivot(string op = "=")(Vector3F pivot) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("this.pivot " ~ op ~ " pivot;");
    updateModelMatrix();
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setPivotX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("pivot.x " ~ op ~ " value;");
    updateModelMatrix();
    return this;
	}

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setPivotY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("pivot.y " ~ op ~ " value;");
    updateModelMatrix();
    return this;
	}

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
	Transform setPivotZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("pivot.z " ~ op ~ " value;");
    updateModelMatrix();
    return this;
	}

  /**
   *
  **/
  ref const(Vector3F) getPivot() pure nothrow const {
    return pivot;
  }
  
  /**
   * Returns model matrix for the object representation.
  **/
	ref const(Matrix4F) getModelMatrix() pure nothrow const {
		return modelMatrix;
	}
 
  /**
   *
  **/
  Entity getParent() pure nothrow {
    return parent;
  }

  private void updateModelMatrix() pure nothrow {
    modelMatrix = tempModelMatrix;
    modelMatrix.c[0][3] += pivot.x;
    modelMatrix.c[1][3] -= pivot.y;
    modelMatrix.c[2][3] += pivot.z;
  }
}