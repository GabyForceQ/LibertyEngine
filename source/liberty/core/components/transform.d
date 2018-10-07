/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/transform.d, _transform.d)
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
   *
  **/
	ref Transform translate(Vector3F translation) pure nothrow {
		position += translation;
		modelMatrix.translate(translation);
		return this;
	}

  /**
   *
  **/
	void translateX(float value) pure nothrow {
		position += Vector3F(value, 0.0f, 0.0f);
		modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
	}
  
  /**
   *
  **/
	void translateY(float value) pure nothrow {
		position += Vector3F(0.0f, value, 0.0f);
		modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
	}
  
  /**
   *
  **/
	void translateZ(float value) pure nothrow {
		position += Vector3F(0.0f, 0.0f, value);
		modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
	}
  
  /**
   *
  **/
	void rotate(float angle, float rotationX, float rotationY, float rotationZ) pure nothrow {
		modelMatrix.rotate(angle, Vector3F(rotationX, rotationY, rotationZ));
	}
  
  /**
   *
  **/
	void rotate(float angle, Vector3F rotation) pure nothrow {
		modelMatrix.rotate(angle, rotation);
	}
  
  /**
   *
  **/
	void rotatePitch(float angle) pure nothrow {
		modelMatrix.rotateX(angle.radians);
	}

  /**
   *
  **/
	void rotateYaw(float angle) pure nothrow {
		modelMatrix.rotateY(angle.radians);
	}

  /**
   *
  **/
	void rotateRoll(float angle) pure nothrow {
		modelMatrix.rotateZ(angle.radians);
	}
  
  /**
   *
  **/
	void scale(float x, float y, float z) pure nothrow {
		modelMatrix.scale(Vector3F(x, y, z));
	}
  
  /**
   *
  **/
	void scale(Vector3F scaling) pure nothrow {
		modelMatrix.scale(scaling);
	}
  
  /**
   *
  **/
	void scaleX(float value) pure nothrow {
		modelMatrix.scale(Vector3F(value, 0.0f, 0.0f));
	}
  
  /**
   *
  **/
	void scaleY(float value) pure nothrow {
		modelMatrix.scale(Vector3F(0.0f, value, 0.0f));
	}
  
  /**
   *
  **/
	void scaleZ(float value) pure nothrow {
		modelMatrix.scale(Vector3F(0.0f, 0.0f, value));
	}
  
  /**
   *
  **/
	ref const(Vector3F) getPosition() pure nothrow const {
		return position;
	}
  
  /**
   *
  **/
	ref const(Vector3F) getRotation() pure nothrow const {
		return rotation;
	}
  
  /**
   *
  **/
	ref const(Vector3F) getScale() pure nothrow const {
		return scaling;
	}
  
  /**
   *
  **/
	ref const(Matrix4F) getModelMatrix() pure nothrow const {
		return modelMatrix;
	}
}