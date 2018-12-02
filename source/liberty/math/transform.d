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
import liberty.scene.meta;
import liberty.scene.node;
import liberty.primitive.vertex;
import liberty.terrain.vertex;
import liberty.surface.widget;
import liberty.core.platform;

/**
 *
**/
final class Transform(byte N) if (N == 2 || N == 3) {
  private {
    static if (N == 2) {
      // getParent
      Widget parent;
      Matrix4F modelMatrix = Matrix4F.identity();

      Vector2I location = Vector2I.zero;
      Vector2I scale = Vector2I(100, 100);
    } else {
      // getParent
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
  }

  static if (N == 2)
    /**
     *
    **/
    this(Widget parent) {
      this.parent = parent;

      location = Vector2I(Platform.getWindow.getWidth / 2, Platform.getWindow.getHeight / 2);
      modelMatrix.setTranslation(Vector3F(location.x, -location.y, 0.0f));
      modelMatrix.setScale(Vector3F(scale.x / 2, scale.y / 2, 1.0f));
    }
  else {
    /**
     *
    **/
    this(SceneNode parent) pure nothrow {
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
  }

  /**
   *
  **/
  static if (N == 2)
  Transform2 setLocation(string op = "=")(int x, int y) pure nothrow {
    return setLocation!op(Vector2I(x, y));
  }

  /**
   *
  **/
  static if (N == 2)
  Transform2 setLocation(string op = "=")(Vector2I location) pure nothrow {
    static if (op == "=")
      modelMatrix.setTranslation(Vector3F(location.x, -location.y, 0.0f));
    else static if (op == "+=")
      modelMatrix.setTranslation(Vector3F(this.location.x + location.x, -(this.location.y + location.y), 0.0f));
    else static if (op == "-=")
      modelMatrix.setTranslation(Vector3F(this.location.x - location.x, -(this.location.y - location.y), 0.0f));
    
    mixin("this.location " ~ op ~ " location;");
    return this;
  }

  /**
   *
  **/
  static if (N == 2)
  Vector2I getLocation() pure nothrow const {
    return location;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
  Transform setRelativeLocation(string op = "=")(float x, float y, float z) pure {
    return setRelativeLocation!op(Vector3F(x, y, z));
  }

  /**
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
  Transform setRelativeLocation(string op = "=")(Vector3F location) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {  
    mixin("tempModelMatrix.c[0][3] " ~ op ~ " location.x;");
    mixin("tempModelMatrix.c[1][3] " ~ op ~ " location.y;");
    mixin("tempModelMatrix.c[2][3] " ~ op ~ " location.z;");
    mixin("relativeLocation " ~ op ~ " location;");

    updateModelMatrix();
    return this;
  }

  /**
   * 
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setRelativeLocationX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][3] " ~ op ~ " value;");
    mixin("relativeLocation.x " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}
  
  /**
   * 
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setRelativeLocationY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[1][3] " ~ op ~ " value;");
    mixin("relativeLocation.y " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}

  /**
   * 
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setRelativeLocationZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[2][3] " ~ op ~ " value;");
    mixin("relativeLocation.z " ~ op ~ " value;");

    updateModelMatrix();
    return this;
	}

  /**
   * Translate location using x, y and z scalars as coordinates.
   * Location is done in absolute space.
  **/
  static if (N == 3)
	Transform setAbsoluteLocation(string op = "=", bool force = false)(float x, float y, float z)
  if (op == "=" || op == "+=" || op == "-=")
  do {
		return setAbsoluteLocation!(op, force)(Vector3F(x, y, z));
	}

  /**
   * Translate location using a vector with x, y and z coordinates.
   * Location is done in absolute space.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteLocation(string op = "=", bool force = false)(Vector3F location)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin(forceBody);

    static if (op == "=") {
      mixin("tempModelMatrix.c[0][3] " ~ op ~ "relativeLocation.x + location.x;");
      mixin("tempModelMatrix.c[1][3] " ~ op ~ "relativeLocation.y + location.y;");
      mixin("tempModelMatrix.c[2][3] " ~ op ~ "relativeLocation.z + location.z;");
    } else {
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " location.x;");
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " location.y;");
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " location.z;");
    }
    mixin("absoluteLocation " ~ op ~ " location;");

    // Set location to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteLocation!(op, true)(location);

    updateModelMatrix();
		return this;
	}

  /**
   * Translate x-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteLocationX(string op = "=", bool force = true)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin(forceBody);

    static if (op == "=")
      mixin("tempModelMatrix.c[0][3] " ~ op ~ "relativeLocation.x + value;");
    else
      mixin("tempModelMatrix.c[0][3] " ~ op ~ " value;");
    mixin("absoluteLocation.x " ~ op ~ " value;");

    // Set location x to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteLocationX!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Translate y-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteLocationY(string op = "=", bool force = false)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin(forceBody);

    static if (op == "=")
      mixin("tempModelMatrix.c[1][3] " ~ op ~ "relativeLocation.y + value;");
    else
      mixin("tempModelMatrix.c[1][3] " ~ op ~ " value;");
    mixin("absoluteLocation.y " ~ op ~ " value;");

    // Set location y to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteLocationY!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Translate z-coordinate location.
   * Location is done in absolute space.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteLocationZ(string op = "=", bool force = false)(float value)
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin(forceBody);

    static if (op == "=")
      mixin("tempModelMatrix.c[2][3] " ~ op ~ "relativeLocation.z + value;");
    else
      mixin("tempModelMatrix.c[2][3] " ~ op ~ " value;");
    mixin("absoluteLocation.z " ~ op ~ " value;");

    // Set location z to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteLocationZ!(op, true)(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle and rotation coordinates using scalars x, y and z.
   * Returns reference to this so it can be used in a stream.
  **/
	//Transform setAbsoluteRotation(string op = "=")(float angle, float rotX, float rotY, float rotZ) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {
	//	return setRotation!op(angle, Vector3F(rotX, rotY, rotZ));
	//}
  
  /**
   * Rotate object specifying the rotation angle and a vector of three scalars for x, y and z.
   * Returns reference to this so it can be used in a stream.
  **/
	//Transform setAbsoluteRotation(string op = "=")(float angle, Vector3F rotation) pure
  //if (op == "=" || op == "+=" || op == "-=")
  //do {
  //  // Set rotation to the current object children too
  //  foreach (child; parent.getChildMap())
  //    child.getTransform().setRotation!op(angle, rotation);
  //  
  //  return this;
	//}

  /*Transform setAbsoluteRotation(string op = "=")(Matrix3F rotation) pure
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
    // Set rotation to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteRotation!op(rotation);
    
    updateModelMatrix();
    return this;
	}*/
  
  /**
   * Rotate object specifying the rotation angle for pitch axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform rotatePitch(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("absoluteRotation.x " ~ op ~ " angle;");
		tempModelMatrix.rotateX(absoluteRotation.x.radians);

    // Set pitch rotation to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().rotatePitch!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for yaw axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform rotateYaw(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("absoluteRotation.y " ~ op ~ " angle;");
		tempModelMatrix.rotateY(absoluteRotation.y.radians);

    // Set yaw rotation to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().rotateYaw!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for roll axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform rotateRoll(string op = "=")(float angle) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    mixin("absoluteRotation.z " ~ op ~ " angle;");
		tempModelMatrix.rotateZ(absoluteRotation.z.radians);

    // Set roll rotation to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().rotateRoll!op(angle);

    updateModelMatrix();
    return this;
	}

  /**
   *
  **/
  static if (N == 2)
  Transform2 setScale(string op = "=")(int x, int y) pure nothrow {
    return setScale!op(Vector2I(x, y));
  }

  /**
   *
  **/
  static if (N == 2)
  Transform2 setScale(string op = "=")(Vector2I scale) pure nothrow {
    static if (op == "=")
      modelMatrix.setScale(Vector3F(scale.x / 2.0f, scale.y / 2.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.setScale(Vector3F((this.scale.x + scale.x) / 2.0f, (this.scale.y + scale.y) / 2.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.setScale(Vector3F((this.scale.x - scale.x) / 2.0f, (this.scale.y - scale.y) / 2.0f, 0.0f));

    mixin("this.scale " ~ op ~ " scale;");
    return this;
  }
  
  /**
   *
  **/
  static if (N == 2)
  Vector2I getScale() pure nothrow const {
    return scale;
  }

  /**
   * Scale object using same value for x, y and z coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScale(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setAbsoluteScale!op(Vector3F(value, value, value));
	}
  
  /**
   * Scale object using x, y and z scalars for coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScale(string op = "=")(float x, float y, float z) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setAbsoluteScale!op(Vector3F(x, y, z));
	}
  
  /**
   * Scale object using a vector with x, y and z scalars for coordinates.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScale(string op = "=")(Vector3F scale) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " scale.x;");
    mixin("tempModelMatrix.c[1][1] " ~ op ~ " scale.y;");
    mixin("tempModelMatrix.c[2][2] " ~ op ~ " scale.z;");

    // Set scale to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteScale!op(scale);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on x axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScaleX(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[0][0] " ~ op ~ " value;");

    // Set scale x to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteScaleX!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on y axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScaleY(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[1][1] " ~ op ~ " value;");

    // Set scale y to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteScaleY!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Scale object on z axis.
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
	Transform setAbsoluteScaleZ(string op = "=")(float value) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
		mixin("tempModelMatrix.c[2][2] " ~ op ~ " value;");

    // Set scale z to the current object children too
    foreach (child; parent.getChildMap())
      child.getTransform().setAbsoluteScaleZ!op(value);

    updateModelMatrix();
    return this;
	}
  
  /**
   * Returns object location in relative space.
  **/
  static if (N == 3)
	ref const(Vector3F) getRelativeLocation() pure nothrow const {
		return relativeLocation;
	}

  /**
   * Returns object location in absolute space.
  **/
  static if (N == 3)
	ref const(Vector3F) getAbsoluteLocation() pure nothrow const {
		return absoluteLocation;
	}
  
  /**
   * Returns object rotation in relative space.
  **/
  static if (N == 3)
	ref const(Vector3F) getRelativeRotation() pure nothrow const {
		return relativeRotation;
	}

  /**
   * Returns object rotation in absolute space.
  **/
  static if (N == 3)
	ref const(Vector3F) getAbsoluteRotation() pure nothrow const {
		return absoluteRotation;
	}
  
  /**
   * Returns object scale in relative space.
  **/
  static if (N == 3)
	ref const(Vector3F) getRelativeScale() pure nothrow const {
		return relativeScale;
	}

  /**
   * Returns object scale in absolute space.
  **/
  static if (N == 3)
	ref const(Vector3F) getAbsoluteScale() pure nothrow const {
		return absoluteScale;
	}

  /**
   * Returns object location in true space.
  **/
  static if (N == 3)
	Vector3F getLocation() pure nothrow const {
		return absoluteLocation + relativeLocation;
	}

  /**
   * Returns object rotation in true space.
  **/
  static if (N == 3)
	Vector3F getRotation() pure nothrow const {
		return absoluteRotation + relativeRotation;
	}
  
  /**
   * Returns object scale in true space.
  **/
  static if (N == 3)
	Vector3F getScale() pure nothrow const {
		return absoluteScale + relativeScale;
	}

  /**
   *
  **/
  static if (N == 3)
  Transform setPivot(string op = "=")(float x, float y, float z) pure
  if (op == "=" || op == "+=" || op == "-=")
  do {
    return setPivot!op(Vector3F(x, y, z));
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  static if (N == 3)
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
  static if (N == 3)
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
  static if (N == 3)
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
  static if (N == 3)
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
  static if (N == 3)
  ref const(Vector3F) getPivot() pure nothrow const {
    return pivot;
  }
  
  /**
   * Returns model matrix for the object representation.
  **/
	ref const(Matrix4F) getModelMatrix() pure nothrow const {
		return modelMatrix;
	}

  static if (N == 2)
    /**
     *
    **/
    Widget getParent() pure nothrow {
      return parent;
    }
  else
    /**
     *
    **/
    SceneNode getParent() pure nothrow {
      return parent;
    }

  static if (N == 3)
    private void updateModelMatrix() pure nothrow {
      modelMatrix = tempModelMatrix;
      modelMatrix.c[0][3] += pivot.x;
      modelMatrix.c[1][3] -= pivot.y;
      modelMatrix.c[2][3] += pivot.z;
    }
}

private immutable forceBody = q{
  static if (!force)
    if (!parent.isRootNode()) {
      Logger.warning(
        "You are trying to perform Transformation a non-root object (id: " 
        ~ parent.getId() 
        ~ ") in absolute space.",
        typeof(this).stringof
      );
      return this;
    }
};

/**
 *
**/
alias Transform2 = Transform!2;

/**
 *
**/
alias Transform3 = Transform!3;