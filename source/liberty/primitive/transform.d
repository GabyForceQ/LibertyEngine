/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/transform.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.transform;

import liberty.logger.impl;
import liberty.math.functions;
import liberty.math.vector;
import liberty.math.matrix;
import liberty.meta;
import liberty.scene.node;
import liberty.primitive.vertex;
import liberty.terrain.vertex;

/**
 *
**/
@Component
final class Transform {
  private {
    SceneNode parent;
    Matrix4F modelMatrix = Matrix4F.identity();
    Matrix4F tempModelMatrix = Matrix4F.identity();
    
    Vector3F relativeLocation = Vector3F.zero;
    Vector3F relativeRotation = Vector3F.zero;
    Vector3F relativeScale = Vector3F.one;
    
    Vector3F absoluteLocation = Vector3F.zero;
    Vector3F absoluteRotation = Vector3F.zero;
    Vector3F absoluteScale = Vector3F.one;

    Vector3F pivot = Vector3F.zero;
  }

  /**
   *
  **/
  void setModelMatrix(Matrix4F mat) {
    tempModelMatrix = mat;
  }

  /**
   *
  **/
  this(SceneNode parent) {
    this.parent = parent;
  }

  /**
   *
  **/
  this(SceneNode parent, Transform transform) {
    this(parent);
    absoluteLocation = transform.absoluteLocation;

    tempModelMatrix.c[0][3] += absoluteLocation.x;
    tempModelMatrix.c[1][3] += absoluteLocation.y;
    tempModelMatrix.c[2][3] += absoluteLocation.z;

    updateModelMatrix();
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
  Transform setRelativeLocation(string op = "=")(float x, float y, float z) pure {
    return setRelativeLocation!op(Vector3F(x, y, z));
  }

  /**
   * Returns reference to this and can be used in a stream.
  **/
  Transform setRelativeLocation(string op = "=")(Vector3F location) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {  
    mixin ("tempModelMatrix.c[0][3] " ~ op ~ " location.x;");
    mixin ("tempModelMatrix.c[1][3] " ~ op ~ " location.y;");
    mixin ("tempModelMatrix.c[2][3] " ~ op ~ " location.z;");
    mixin ("relativeLocation " ~ op ~ " location;");

    updateModelMatrix();
    return this;
  }

  /**
   * 
   * Returns reference to this and can be used in a stream.
  **/
	Transform setRelativeLocationX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin ("tempModelMatrix.c[0][3] " ~ op ~ " value;");
    mixin ("relativeLocation.x " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * 
   * Returns reference to this and can be used in a stream.
  **/
	Transform setRelativeLocationY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin ("tempModelMatrix.c[1][3] " ~ op ~ " value;");
    mixin ("relativeLocation.y " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}

  /**
   * 
   * Returns reference to this and can be used in a stream.
  **/
	Transform setRelativeLocationZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin ("tempModelMatrix.c[2][3] " ~ op ~ " value;");
    mixin ("relativeLocation.z " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}

  /**
   * Translate location using x, y and z scalars as coordinates.
   * Location is done in absolute space.
  **/
	Transform setAbsoluteLocation(string op = "=", bool force = false)(float x, float y, float z)
  if (op == "=" || op == "+=" || op == "-=")
  do {
		return setAbsoluteLocation!(op, force)(Vector3F(x, y, z));
	}

  /**
   * Translate location using a vector with x, y and z coordinates.
   * Location is done in absolute space.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteLocation(string op = "=", bool force = false)(Vector3F location)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin (forceBody);

    static if (op == "=") {
      mixin ("tempModelMatrix.c[0][3] " ~ op ~ "relativeLocation.x + location.x;");
      mixin ("tempModelMatrix.c[1][3] " ~ op ~ "relativeLocation.y + location.y;");
      mixin ("tempModelMatrix.c[2][3] " ~ op ~ "relativeLocation.z + location.z;");
    } else {
      mixin ("tempModelMatrix.c[0][3] " ~ op ~ " location.x;");
      mixin ("tempModelMatrix.c[1][3] " ~ op ~ " location.y;");
      mixin ("tempModelMatrix.c[2][3] " ~ op ~ " location.z;");
    }
    mixin ("absoluteLocation " ~ op ~ " location;");

    // Set location to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteLocation!(op, true)(location);

    updateModelMatrix();
		return this;
	}

  /**
   * Translate x-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteLocationX(string op = "=", bool force = true)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin (forceBody);

    static if (op == "=")
      mixin ("tempModelMatrix.c[0][3] " ~ op ~ "relativeLocation.x + value;");
    else
      mixin ("tempModelMatrix.c[0][3] " ~ op ~ " value;");
    mixin ("absoluteLocation.x " ~ op ~ " value;");

    // Set location x to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteLocationX!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Translate y-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteLocationY(string op = "=", bool force = false)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin (forceBody);

    static if (op == "=")
      mixin ("tempModelMatrix.c[1][3] " ~ op ~ "relativeLocation.y + value;");
    else
      mixin ("tempModelMatrix.c[1][3] " ~ op ~ " value;");
    mixin ("absoluteLocation.y " ~ op ~ " value;");

    // Set location y to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteLocationY!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Translate z-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteLocationZ(string op = "=", bool force = false)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin (forceBody);

    static if (op == "=")
      mixin ("tempModelMatrix.c[2][3] " ~ op ~ "relativeLocation.z + value;");
    else
      mixin ("tempModelMatrix.c[2][3] " ~ op ~ " value;");
    mixin ("absoluteLocation.z " ~ op ~ " value;");

    // Set location z to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteLocationZ!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle and rotation coordinates using scalars x, y and z.
   * Returns reference to this and can be used in a stream.
  **/
	//Transform setAbsoluteRotation(string op = "=")(float angle, float rotX, float rotY, float rotZ) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {
	//	return setRotation!op(angle, Vector3F(rotX, rotY, rotZ));
	//}
  
  /**
   * Rotate object specifying the rotation angle and a vector of three scalars for x, y and z.
   * Returns reference to this and can be used in a stream.
  **/
	//Transform setAbsoluteRotation(string op = "=")(float angle, Vector3F rotation) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {
  //  // Set rotation to the current object children too
  //  foreach (child; parent.getChildren())
  //    child.getTransform().setRotation!op(angle, rotation);
  //  
  //  return this;
	//}

  /*Transform setAbsoluteRotation(string op = "=")(Matrix3F rotation) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("tempModelMatrix.c[0][0] " ~ op ~ " rotation.c[0][0];");
    mixin ("tempModelMatrix.c[0][1] " ~ op ~ " rotation.c[0][1];");
    mixin ("tempModelMatrix.c[0][2] " ~ op ~ " rotation.c[0][2];");

    mixin ("tempModelMatrix.c[1][0] " ~ op ~ " rotation.c[1][0];");
    mixin ("tempModelMatrix.c[1][1] " ~ op ~ " rotation.c[1][1];");
    mixin ("tempModelMatrix.c[1][2] " ~ op ~ " rotation.c[1][2];");

    mixin ("tempModelMatrix.c[2][0] " ~ op ~ " rotation.c[2][0];");
    mixin ("tempModelMatrix.c[2][1] " ~ op ~ " rotation.c[2][1];");
    mixin ("tempModelMatrix.c[2][2] " ~ op ~ " rotation.c[2][2];");

    // Set rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteRotation!op(rotation);
    
    updateModelMatrix();
    return this;
	}*/
  
  /**
   * Rotate object specifying the rotation angle for pitch axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform rotatePitch(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("absoluteRotation.x " ~ op ~ " angle;");
		tempModelMatrix.rotateX(absoluteRotation.x.radians);

    // Set pitch rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotatePitch!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for yaw axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform rotateYaw(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("absoluteRotation.y " ~ op ~ " angle;");
		tempModelMatrix.rotateY(absoluteRotation.y.radians);

    // Set yaw rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotateYaw!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for roll axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform rotateRoll(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("absoluteRotation.z " ~ op ~ " angle;");
		tempModelMatrix.rotateZ(absoluteRotation.z.radians);

    // Set roll rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotateRoll!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   * Scale object using same value for x, y and z coordinates.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScale(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setAbsoluteScale!op(Vector3F(value, value, value));
	}
  
  /**
   * Scale object using x, y and z scalars for coordinates.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScale(string op = "=")(float x, float y, float z) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setAbsoluteScale!op(Vector3F(x, y, z));
	}
  
  /**
   * Scale object using a vector with x, y and z scalars for coordinates.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScale(string op = "=")(Vector3F scale) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " scale.x;");
    mixin("tempModelMatrix.c[1][1] " ~ op ~ " scale.y;");
    mixin("tempModelMatrix.c[2][2] " ~ op ~ " scale.z;");

    // Set scale to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteScale!op(scale);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on x axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScaleX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " value;");

    // Set scale x to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteScaleX!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on y axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScaleY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[1][1] " ~ op ~ " value;");

    // Set scale y to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteScaleY!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on z axis.
   * Returns reference to this and can be used in a stream.
  **/
	Transform setAbsoluteScaleZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[2][2] " ~ op ~ " value;");

    // Set scale z to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setAbsoluteScaleZ!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Returns object location in relative space.
  **/
	ref const(Vector3F) getRelativeLocation() pure nothrow const {
		return relativeLocation;
	}

  /**
   * Returns object location in absolute space.
  **/
	ref const(Vector3F) getAbsoluteLocation() pure nothrow const {
		return absoluteLocation;
	}
  
  /**
   * Returns object rotation in relative space.
  **/
	ref const(Vector3F) getRelativeRotation() pure nothrow const {
		return relativeRotation;
	}

  /**
   * Returns object rotation in absolute space.
  **/
	ref const(Vector3F) getAbsoluteRotation() pure nothrow const {
		return absoluteRotation;
	}
  
  /**
   * Returns object scale in relative space.
  **/
	ref const(Vector3F) getRelativeScale() pure nothrow const {
		return relativeScale;
	}

  /**
   * Returns object scale in absolute space.
  **/
	ref const(Vector3F) getAbsoluteScale() pure nothrow const {
		return absoluteScale;
	}

  /**
   * Returns object location in true space.
  **/
	Vector3F getLocation() pure nothrow const {
		return absoluteLocation + relativeLocation;
	}

  /**
   * Returns object rotation in true space.
  **/
	Vector3F getRotation() pure nothrow const {
		return absoluteRotation + relativeRotation;
	}
  
  /**
   * Returns object scale in true space.
  **/
	Vector3F getScale() pure nothrow const {
		return absoluteScale + relativeScale;
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
   * Returns reference to this and can be used in a stream.
  **/
  Transform setPivot(string op = "=")(Vector3F pivot) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("this.pivot " ~ op ~ " pivot;");
    updateModelMatrix();
    return this;
  }

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
	Transform setPivotX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("pivot.x " ~ op ~ " value;");
    updateModelMatrix();
    return this;
	}

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
	Transform setPivotY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("pivot.y " ~ op ~ " value;");
    updateModelMatrix();
    return this;
	}

  /**
   *
   * Returns reference to this and can be used in a stream.
  **/
	Transform setPivotZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin ("pivot.z " ~ op ~ " value;");
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

  private void updateModelMatrix() pure nothrow {
    modelMatrix = tempModelMatrix;
    modelMatrix.c[0][3] += pivot.x;
    modelMatrix.c[1][3] -= pivot.y;
    modelMatrix.c[2][3] += pivot.z;
  }
}

private immutable forceBody = q{
  static if (!force)
    if (!parent.isRootObject()) {
      Logger.warning(
        "You are trying to perform Transformation a non-root object (id: " 
        ~ parent.getId() 
        ~ ") in absolute space.",
        typeof(this).stringof
      );
      return this;
    }
};