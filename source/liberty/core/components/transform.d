/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/transform.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.components.transform;

import liberty.core.logger.impl : Logger;
import liberty.core.math.functions : radians;
import liberty.core.math.vector : Vector3F;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.objects : WorldObject;

/**
 *
**/
struct Transform {
  private {
    WorldObject parent;
    Matrix4F modelMatrix = Matrix4F.identity();
    
    Vector3F localPosition = Vector3F.zero;
    Vector3F localRotation = Vector3F.zero;
    Vector3F localScaling = Vector3F.one;
    
    Vector3F worldPosition = Vector3F.zero;
    Vector3F worldRotation = Vector3F.zero;
    Vector3F worldScaling = Vector3F.one;

    Vector3F pivot = Vector3F.zero;
  }


  /**
   *
  **/
  this(WorldObject parent) {
    this.parent = parent;
  }

  /**
   *
  **/
  this(WorldObject parent, Transform transform) {
    this(parent);
    
    worldPosition = transform.worldPosition;
    modelMatrix.translate(worldPosition);
  }

  /**
   *
   * Returns reference to this.
  **/
  ref const(Transform) setLocalPosition(string op = "=")(float x, float y, float z) pure {
    return setLocalPosition!op(Vector3F(x, y, z));
  }

  /**
   * Returns reference to this.
  **/
  ref const(Transform) setLocalPosition(string op = "=")(Vector3F position) pure {
    static if (op == "=")
      modelMatrix.translate(-this.localPosition + position);
    else static if (op == "+=")
      modelMatrix.translate(position);
    else static if (op == "-=")
      modelMatrix.translate(-position);
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("localPosition " ~ op ~ " position;");

    return this;
  }

  /**
   * 
   * Returns reference to this.
  **/
	ref Transform setLocalPositionX(string op = "=")(float value) pure {
		static if (op == "=")
      modelMatrix.translate(Vector3F(-localPosition.x + value, 0.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(-value, 0.0f, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("localPosition.x " ~ op ~ " value;");

    return this;
	}
  
  /**
   * 
   * Returns reference to this.
  **/
	ref Transform setLocalPositionY(string op = "=")(float value) pure {
		static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, -localPosition.y + value, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, -value, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("localPosition.y " ~ op ~ " value;");

    return this;
	}

  /**
   * 
   * Returns reference to this.
  **/
	ref Transform setLocalPositionZ(string op = "=")(float value) pure {
		static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -localPosition.z + value));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -value));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("localPosition.z " ~ op ~ " value;");

    return this;
	}

  /**
   * Translate position using x, y and z scalars as coordinates.
   * Translation is done in world space.
  **/
	ref Transform setWorldPosition(string op = "=", bool force = false)(float x, float y, float z)  {
		return setWorldPosition!(op, force)(Vector3F(x, y, z));
	}

  /**
   * Translate position using a vector with x, y and z coordinates.
   * Translation is done in world space.
   * Returns reference to this.
  **/
	ref Transform setWorldPosition(string op = "=", bool force = false)(Vector3F position)  {
    mixin (forceBody);

    static if (op == "=")
      modelMatrix.translate(-this.worldPosition + position);
    else static if (op == "+=")
      modelMatrix.translate(position);
    else static if (op == "-=")
      modelMatrix.translate(-position);
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("worldPosition " ~ op ~ " position;");

    // Set position to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setWorldPosition!(op, true)(position);

		return this;
	}

  /**
   * Translate x-coordinate position.
   * Translation is done in world space.
   * Returns reference to this.
  **/
	ref Transform setWorldPositionX(string op = "=", bool force = true)(float value) {
    mixin (forceBody);

		static if (op == "=")
      modelMatrix.translate(Vector3F(-worldPosition.x + value, 0.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(-value, 0.0f, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("worldPosition.x " ~ op ~ " value;");

    // Set position x to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setWorldPositionX!(op, true)(value);

    return this;
	}
  
  /**
   * Translate y-coordinate position.
   * Translation is done in world space.
   * Returns reference to this.
  **/
	ref Transform setWorldPositionY(string op = "=", bool force = false)(float value) {
    mixin (forceBody);

    static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, -worldPosition.y + value, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, -value, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("worldPosition.y " ~ op ~ " value;");

    // Set position y to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setWorldPositionY!(op, true)(value);

    return this;
	}
  
  /**
   * Translate z-coordinate position.
   * Translation is done in world space.
   * Returns reference to this.
  **/
	ref Transform setWorldPositionZ(string op = "=", bool force = false)(float value) {
    mixin (forceBody);

		static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -worldPosition.z + value));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -value));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("worldPosition.z " ~ op ~ " value;");

    // Set position z to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setWorldPositionZ!(op, true)(value);

    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle and rotation coordinates using scalars x, y and z.
   * Returns reference to this.
  **/
	ref Transform setRotation(string op = "=")(float angle, float rotX, float rotY, float rotZ) pure {
		return setRotation!op(angle, Vector3F(rotX, rotY, rotZ));
	}
  
  /**
   * Rotate object specifying the rotation angle and a vector of three scalars for x, y and z.
   * Returns reference to this.
  **/
	ref Transform setRotation(string op = "=")(float angle, Vector3F rotation) pure {
    static if (op == "=")
      assert(0, "Not implemented yet.");
    static if (op == "+=")
		  modelMatrix.rotate(angle, rotation);
    else static if (op == "-=")
      modelMatrix.rotate(-angle, rotation);
    else
      static assert(0, "Only =, +=, -= acceped.");

    // Set rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().setRotation!op(angle, rotation);
    
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle for pitch axis.
   * Returns reference to this.
  **/
	ref Transform rotatePitch(float angle) pure {
		modelMatrix.rotateX(angle.radians);

    // Set pitch rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotatePitch(angle);

    return this;
	}

  /**
   * Rotate object specifying the rotation angle for yaw axis.
   * Returns reference to this.
  **/
	ref Transform rotateYaw(float angle) pure {
		modelMatrix.rotateY(angle.radians);

    // Set yaw rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotateYaw(angle);

    return this;
	}

  /**
   * Rotate object specifying the rotation angle for roll axis.
   * Returns reference to this.
  **/
	ref Transform rotateRoll(float angle) pure {
		modelMatrix.rotateZ(angle.radians);

    // Set roll rotation to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().rotateRoll(angle);

    return this;
	}

  /**
   * Scale object using same value for x, y and z coordinates.
   * Returns reference to this.
  **/
	ref Transform scale(float value) pure {
		modelMatrix.scale(Vector3F(value));

    // Set scale to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scale(value);

    return this;
	}
  
  /**
   * Scale object using x, y and z scalars for coordinates.
   * Returns reference to this.
  **/
	ref Transform scale(float x, float y, float z) pure {
		modelMatrix.scale(Vector3F(x, y, z));

    // Set scale to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scale(x, y, z);

    return this;
	}
  
  /**
   * Scale object using a vector with x, y and z scalars for coordinates.
   * Returns reference to this.
  **/
	ref Transform scale(Vector3F scaling) pure {
		modelMatrix.scale(scaling);

    // Set scale to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scale(scaling);

    return this;
	}
  
  /**
   * Scale object on x axis.
   * Returns reference to this.
  **/
	ref Transform scaleX(float value) pure {
		modelMatrix.scale(Vector3F(value, 0.0f, 0.0f));

    // Set scale x to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scaleX(value);

    return this;
	}
  
  /**
   * Scale object on y axis.
   * Returns reference to this.
  **/
	ref Transform scaleY(float value) pure {
		modelMatrix.scale(Vector3F(0.0f, value, 0.0f));

    // Set scale y to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scaleY(value);

    return this;
	}
  
  /**
   * Scale object on z axis.
   * Returns reference to this.
  **/
	ref Transform scaleZ(float value) pure {
		modelMatrix.scale(Vector3F(0.0f, 0.0f, value));

    // Set scale z to the current object children too
    foreach (child; parent.getChildren())
      child.getTransform().scaleZ(value);

    return this;
	}
  
  /**
   * Returns object position in local space.
  **/
	ref const(Vector3F) getLocalPosition() pure nothrow const {
		return localPosition;
	}

  /**
   * Returns object position in world space.
  **/
	ref const(Vector3F) getWorldPosition() pure nothrow const {
		return worldPosition;
	}
  
  /**
   * Returns object rotation in local space.
  **/
	ref const(Vector3F) getLocalRotation() pure nothrow const {
		return localRotation;
	}

  /**
   * Returns object rotation in world space.
  **/
	ref const(Vector3F) getWorldRotation() pure nothrow const {
		return worldRotation;
	}
  
  /**
   * Returns object scale in local space.
  **/
	ref const(Vector3F) getLocalScale() pure nothrow const {
		return localScaling;
	}

  /**
   * Returns object scale in world space.
  **/
	ref const(Vector3F) getWorldScale() pure nothrow const {
		return worldScaling;
	}

  /**
   * Returns object position in true space.
  **/
	Vector3F getPosition() pure nothrow const {
		return worldPosition + localPosition;
	}

  /**
   * Returns object rotation in true space.
  **/
	Vector3F getRotation() pure nothrow const {
		return worldRotation + localRotation;
	}
  
  /**
   * Returns object scale in true space.
  **/
	Vector3F getScale() pure nothrow const {
		return worldScaling + localScaling;
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
  ref const(Transform) setPivot(string op = "=")(float x, float y, float z) pure {
    return setPivot!op(Vector3F(x, y, z));
  }

  /**
   *
   * Returns reference to this.
  **/
  ref const(Transform) setPivot(string op = "=")(Vector3F pivot) pure {
    static if (op == "=")
      modelMatrix.translate(-this.pivot + pivot);
    else static if (op == "+=")
      modelMatrix.translate(pivot);
    else static if (op == "-=")
      modelMatrix.translate(-pivot);
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("this.pivot " ~ op ~ " pivot;");
    
    return this;
  }

  /**
   *
   * Returns reference to this.
  **/
	ref Transform setPivotX(string op = "=")(float value) pure {
    static if (op == "=")
      modelMatrix.translate(Vector3F(-pivot.x + value, 0.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(-value, 0.0f, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    
    mixin ("pivot.x " ~ op ~ " value;");
    return this;
	}

  /**
   *
   * Returns reference to this.
  **/
	ref Transform setPivotY(string op = "=")(float value) pure {
    static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, -pivot.y + value, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, -value, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");
    
    mixin ("pivot.y " ~ op ~ " value;");

    return this;
	}

  /**
   *
   * Returns reference to this.
  **/
	ref Transform setPivotZ(string op = "=")(float value) pure {
    static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -pivot.z + value));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -value));
    else
      static assert(0, "Only =, +=, -= acceped.");

    
    mixin ("pivot.z " ~ op ~ " value;");
    return this;
	}

  /**
   *
  **/
  ref const(Vector3F) getPivot() pure nothrow const {
    return pivot;
  }
}

private immutable forceBody = q{
  static if (!force)
    if (!parent.isRootObject()) {
      Logger.warning(
        "You are trying to perform transformation a non-root object (id: " 
        ~ parent.getId() 
        ~ ") in world space.",
        typeof(this).stringof
      );
      return this;
    }
};