/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/raw.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.raw;

/**
 *
**/
class RawModel {
  private {
    uint vaoID;
    size_t vertexCount;
  }

  /**
   *
  **/
  this(uint vaoID, size_t vertexCount) {
    this.vaoID = vaoID;
    this.vertexCount = vertexCount;
  }

  /**
   *
  **/
  uint getVaoID() {
    return vaoID;
  }

  /**
   *
  **/
  size_t getVertexCount() {
    return vertexCount;
  }
}