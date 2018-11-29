/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/data.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.data;

/**
 * Data structure for $(D Model) class.
 * You should load it only using method $(D ModelIO.loadRawModel).
**/
struct RawModel {
  /**
   * Vertex array object's ID.
  **/
  uint vaoID;
  
  /**
   * Number of vertices.
  **/
  size_t vertexCount;
  
  /**
   * The model draw option.
  **/
  bool useIndices;
}