/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/transform.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.components.transform;

import liberty.core.math.functions : radians;
import liberty.core.math.vector : Vector3F;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.objects : WorldObject;

/**
 *
**/
struct Transform {
  private {
    Matrix4F modelMatrix = Matrix4F.identity();
    Vector3F position;
    Vector3F rotation;
    Vector3F scaling;
    WorldObject parent;
  }

  /**
   *
  **/
  this(WorldObject parent, Vector3F position = Vector3F.zero, 
  Vector3F rotation = Vector3F.zero, Vector3F scaling = Vector3F.one) {
    this.parent = parent;
    this.position = position;
    this.rotation = rotation;
    this.scaling = scaling;
  }

  /**
   * Translate position using x, y and z scalars as coordinates.
  **/
	ref Transform setPosition(string op = "=")(float x, float y, float z) pure nothrow {
		return setPosition!op(Vector3F(x, y, z));
	}

  /**
   * Translate position using a vector with x, y and z coordinates.
  **/
	ref Transform setPosition(string op = "=")(Vector3F position) pure nothrow {  
    static if (op == "=")
      modelMatrix.translate(-this.position + position);
    else static if (op == "+=")
      modelMatrix.translate(position);
    else static if (op == "-=")
      modelMatrix.translate(-position);
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("this.position " ~ op ~ " position;");
		return this;
	}

  /**
   * Translate x-coordinate position.
  **/
	ref Transform setPositionX(string op = "=")(float value) pure nothrow {
		static if (op == "=")
      modelMatrix.translate(Vector3F(-position.x + value, 0.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(-value, 0.0f, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("this.position.x " ~ op ~ " value;");
    return this;
	}
  
  /**
   * Translate y-coordinate position.
  **/
	ref Transform setPositionY(string op = "=")(float value) pure nothrow {
    static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, -position.y + value, 0.0f));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, -value, 0.0f));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("this.position.y " ~ op ~ " value;");
    return this;
	}
  
  /**
   * Translate z-coordinate position.
  **/
	ref Transform setPositionZ(string op = "=")(float value) pure nothrow {
		static if (op == "=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -position.z + value));
    else static if (op == "+=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
    else static if (op == "-=")
      modelMatrix.translate(Vector3F(0.0f, 0.0f, -value));
    else
      static assert(0, "Only =, +=, -= acceped.");

    mixin ("this.position.z " ~ op ~ " value;");
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle and rotation coordinates using scalars x, y and z.
  **/
	ref Transform setRotation(string op = "=")(float angle, float rotX, float rotY, float rotZ) pure nothrow {
		return setRotation!op(angle, Vector3F(rotX, rotY, rotZ));
	}
  
  /**
   * Rotate object specifying the rotation angle and a vector of three scalars for x, y and z.
  **/
	ref Transform setRotation(string op = "=")(float angle, Vector3F rotation) pure nothrow {
    static if (op == "=")
      assert(0, "Not implemented yet.");
    static if (op == "+=")
		  modelMatrix.rotate(angle, rotation);
    else static if (op == "-=")
      modelMatrix.rotate(-angle, rotation);
    else
      static assert(0, "Only =, +=, -= acceped.");
    
    return this;
	}
  
  /**
   * Rotate object specifying the rotation angle for pitch axis.
  **/
	ref Transform rotatePitch(float angle) pure nothrow {
		modelMatrix.rotateX(angle.radians);
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for yaw axis.
  **/
	ref Transform rotateYaw(float angle) pure nothrow {
		modelMatrix.rotateY(angle.radians);
    return this;
	}

  /**
   * Rotate object specifying the rotation angle for roll axis.
  **/
	ref Transform rotateRoll(float angle) pure nothrow {
		modelMatrix.rotateZ(angle.radians);
    return this;
	}

  /**
   * Scale object using same value for x, y and z coordinates.
  **/
	ref Transform scale(float value) pure nothrow {
		modelMatrix.scale(Vector3F(value));
    return this;
	}
  
  /**
   * Scale object using x, y and z scalars for coordinates.
  **/
	ref Transform scale(float x, float y, float z) pure nothrow {
		modelMatrix.scale(Vector3F(x, y, z));
    return this;
	}
  
  /**
   * Scale object using a vector with x, y and z scalars for coordinates.
  **/
	ref Transform scale(Vector3F scaling) pure nothrow {
		modelMatrix.scale(scaling);
    return this;
	}
  
  /**
   * Scale object on x axis.
  **/
	ref Transform scaleX(float value) pure nothrow {
		modelMatrix.scale(Vector3F(value, 0.0f, 0.0f));
    return this;
	}
  
  /**
   * Scale object on y axis.
  **/
	ref Transform scaleY(float value) pure nothrow {
		modelMatrix.scale(Vector3F(0.0f, value, 0.0f));
    return this;
	}
  
  /**
   * Scale object on z axis.
  **/
	ref Transform scaleZ(float value) pure nothrow {
		modelMatrix.scale(Vector3F(0.0f, 0.0f, value));
    return this;
	}
  
  /**
   * Returns: object position in world space.
  **/
	ref const(Vector3F) getWorldPosition() pure nothrow const {
		return position;
	}
  
  /**
   * Returns: object rotation in local space.
  **/
	ref const(Vector3F) getLocalRotation() pure nothrow const {
		return rotation;
	}
  
  /**
   * Returns: object scale in local space.
  **/
	ref const(Vector3F) getLocalScale() pure nothrow const {
		return scaling;
	}
  
  /**
   * Returns: model matrix for the object representation.
  **/
	ref const(Matrix4F) getModelMatrix() pure nothrow const {
		return modelMatrix;
	}
}