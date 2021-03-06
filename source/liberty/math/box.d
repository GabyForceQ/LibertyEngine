/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			    $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/box.d)
 * Documentation:
 * Coverage:
**/
module liberty.math.box;

import liberty.math.vector;

/**
 *
**/
struct Box(T, int N) if (N >= 1 && N <= 3) {
  /**
   *
  **/
	enum dim = N;

  /**
   *
  **/
	alias type = T;

  /**
   *
  **/
	alias BoundType = Vector!(T, N);

  /**
   *
  **/
	BoundType min;

  /**
   *
  **/
	BoundType max;

  /**
   *
  **/
	this(BoundType min, BoundType max)   {
		this.min = min;
		this.max = max;
	}

	static if (N == 1) {
    /**
     *
    **/
		this(T min, T max)   {
			this.min.x = min;
			this.max.x = max;
		}
	}

	static if (N == 2) {
    /**
     *
    **/
		this(T min_x, T min_y, T max_x, T max_y)   {
			min = BoundType(min_x, min_y);
			max = BoundType(max_x, max_y);
		}
	}

	static if (N == 3) {
    /**
     *
    **/
		this(T min_x, T min_y, T min_z, T max_x, T max_y, T max_z)   {
			min = BoundType(min_x, min_y, min_z);
			max = BoundType(max_x, max_y, max_z);
		}
	}

  /**
   * Returns box dimensions.
  **/
	BoundType getSize()   const {
		return max - min;
	}

  /**
   * Returns box center.
  **/
	BoundType getCenter()   const {
		return (min + max) / 2;
	}

  /**
   * Returns box width .
  **/
	T getWidth()   const {
		return max.x - min.x;
	}

	static if (N >= 2) {
    /**
     * Returns box height.
    **/
		T getHeight()   const {
			return max.y - min.y;
		}
	}

  
	static if (N >= 3) {
    /**
     * Returns depth of the box.
    **/
		T getDepth()   const {
			return max.z - min.z;
		}
	}

  /**
   * Returns signed volume of the box.
  **/
	T getVolume()   const {
		T ret = 1;
		BoundType size = getSize();
		static foreach (i; 0..N) {
			ret *= size[i];
		}
		return ret;
	}

  /**
   * Returns true if empty.
  **/
	bool isEmpty()   const {
		//const BoundType size = getSize();
		static foreach (i; 0..N) {
			if (min[i] == max[i]) {
				return true;
			}
		}
		return false;
	}

  /**
   * Returns true if it contains point
  **/
	bool contains(BoundType point)   const
	in {
		assert(isSorted());
	} do {
		static foreach (i; 0..N) {
			if (!(point[i] >= min[i] && point[i] < max[i])) {
				return false;
			}
		}
		return true;
	}

  /**
   *
  **/
	bool contains(Box other)   const
	in {
		assert(isSorted());
		assert(other.isSorted());
	} do {
		static foreach (i; 0..N) {
			if ((other.min[i] < min[i]) || (other.max[i] > max[i])) {
				return false;
			}
		}
		return true;
	}

  /**
   *
  **/
	real getSquaredDistance(BoundType point)   const
	in {
		assert(isSorted());
	} do {
		real distanceSquared = 0;
		static foreach (i; 0..N) {
			if (point[i] < min[i]) {
				distanceSquared += (point[i] - min[i]) ^^ 2;
			}
			if (point[i] > max[i]) {
				distanceSquared += (point[i] - max[i]) ^^ 2;
			}
		}
		return distanceSquared;
	}

  /**
   *
  **/
	real getDistance(BoundType point)   const {
		import liberty.math.functions : sqrt;
		return sqrt(getSquaredDistance(point));
	}

  /**
   *
  **/
	real getSquaredDistance(Box o)   const
	in {
		assert(isSorted());
		assert(o.isSorted());
	} do {
		real distanceSquared = 0;
		static foreach (i; 0..N) {
			if (o.max[i] < min[i]) {
				distanceSquared += (o.max[i] - min[i]) ^^ 2;
			}
			if (o.min[i] > max[i]) {
				distanceSquared += (o.min[i] - max[i]) ^^ 2;
			}
		}
		return distanceSquared;
	}

  /**
   *
  **/
	real getDistance(Box o)   const {
		import liberty.math.functions : sqrt;
		return sqrt(getSquaredDistance(o));
	}

  /**
   *
  **/
	Box getIntersection(Box o)   const
	in {
		assert(isSorted());
		assert(o.isSorted());
	} do {
		if (isEmpty()) {
			return this;
		}
		if (o.isEmpty()) {
			return o;
		}
		Box ret;
		T maxOfMins = 0;
		T minOfMaxs = 0;
		static foreach (i; 0..N) {
			maxOfMins = (min.v[i] > o.min.v[i]) ? min.v[i] : o.min.v[i];
			minOfMaxs = (max.v[i] < o.max.v[i]) ? max.v[i] : o.max.v[i];
			ret.min.v[i] = maxOfMins;
			ret.max.v[i] = minOfMaxs >= maxOfMins ? minOfMaxs : maxOfMins;
		}
		return ret;
	}

  /**
   *
  **/
	bool intersects(Box other)   const {
		Box inter = this.getIntersection(other);
		return inter.isSorted() && !inter.isEmpty();
	}

  /**
   *
  **/
	Box grow(BoundType space)   const {
		Box ret = this;
		ret.min -= space;
		ret.max += space;
		return ret;
	}

  /**
   *
  **/
	Box shrink(BoundType space)   const {
		return grow(-space);
	}

  /**
   *
  **/
	Box grow(T space)   const {
		return grow(BoundType(space));
	}

  /**
   *
  **/
	Box translate(BoundType offset)   const {
		return Box(min + offset, max + offset);
	}

  /**
   *
  **/
	Box shrink(T space)   const {
		return shrink(BoundType(space));
	}

  /**
   *
  **/
	Box expand(BoundType point)   const {
		import liberty.math.vector : minByElem, maxByElem;
		return Box(minByElem(min, point), maxByElem(max, point));
	}

  /**
   *
  **/
	Box expand(Box other)   const
	in {
		assert(isSorted());
		assert(other.isSorted());
	} do {
		if (isEmpty()) {
			return other;
		}
		if (other.isEmpty()) {
			return this;
		}
		Box ret;
		T minOfMins = 0;
		T maxOfMaxs = 0;
		static foreach (i; 0..N) {
			minOfMins = (min.v[i] < other.min.v[i]) ? min.v[i] : other.min.v[i];
			maxOfMaxs = (max.v[i] > other.max.v[i]) ? max.v[i] : other.max.v[i];
			ret.min.v[i] = minOfMins;
			ret.max.v[i] = maxOfMaxs;
		}
		return ret;
	}

  /**
   *
  **/
	bool isSorted()   const {
		static foreach (i; 0..N) {
			if (min[i] > max[i]) {
				return false;
			}
		}
		return true;
	}

  /**
   *
  **/
	ref Box opAssign(U)(U x)  if (isBox!U) {
		static if(is(U.type : T)) {
			static if(U.dim == dim) {
				min = x.min;
				max = x.max;
			} else  {
				static assert(false, "No conversion between boxes with different dimensions available!");
			}
		} else {
			static assert(false, "No conversion from " ~ U.type.stringof ~ " to " ~ type.stringof ~ " available!");
		}
		return this;
	}

  /**
   *
  **/
	bool opEquals(U)(U other)   const if (is(U : Box)) {
		return (min == other.min) && (max == other.max);
	}

  /**
   *
  **/
  //size_t toHash()   const {
  //  size_t hash = min.hashOf();
  //  hash = max.hashOf(hash);
  //  return hash;
  //}

  /**
   * Cast to other box types.
  **/
	U opCast(U)()   const if (isBox!U) {
		U b = void;
		static foreach (i; 0..N) {
			b.min[i] = cast(U.type)(min[i]);
			b.max[i] = cast(U.type)(max[i]);
		}
		return b;
	}

	static if (N == 2) {
    /**
     *
    **/
		static Box rectangle(T x, T y, T width, T height)   {
			return Box(x, y, x + width, y + height);
		}
	}
}

/**
 *
**/
template Box2(T) {
	alias Box2 = Box!(T, 2);
}

/**
 *
**/
template Box3(T) {
	alias Box3 = Box!(T, 3);
}

/**
 *
**/
alias Box2I = Box2!int;

/**
 *
**/
alias Box3I = Box3!int;

/**
 *
**/
alias Box2F = Box2!float;

/**
 *
**/
alias Box3F = Box3!float;

/**
 *
**/
alias Box2D = Box2!double;

/**
 *
**/
alias Box3D = Box3!double;