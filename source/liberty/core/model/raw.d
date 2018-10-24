/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/raw.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.raw;

/**
 *
**/
class RawModel {
  private {
    uint vaoID;
    uint vertexCount;
  }

  /**
   *
  **/
  this(uint vaoID, uint vertexCount) {
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
  uint getVertexCount() {
    return vertexCount;
  }
}