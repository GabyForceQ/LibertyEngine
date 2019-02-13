/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/character.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.character;

import liberty.math.vector;

/**
 * Holds information about a certain glyph in the font texture atlas.
 * All sizes are defined for a font-size of 1 point.
**/
final class Character {
  private {
    // getASCIIValue
    int id;

    // getTexCoords
    Vector2F texCoords;
    // getMaxTexCoords
    Vector2F maxTexCoords;
    // getOffset
    Vector2F offset;
    // getSize
    Vector2F size;
    // getAdvance
    Vector2F advance;
  }

  /**
   * $(D_PARAM id):
   *    - stores the ASCII value of the character.
   * $(D_PARAM texCoords):
   *    - x: stores the texture x-coordinate for the top left corner of the character in texture atlas.
   *    - y: stores the texture y-coordinate for the top left corner of the character in texture atlas.
   * $(D_PARAM texSize):
   *    - x: stores the width of the character in the texture atlas.
   *    - y: stores the height of the character in the texture atlas.
   * $(D_PARAM offset):
   *    - x: stores the x distance from the curser to the left edge of the character's quad.
   *    - y: stores the y distance from the curser to the top edge of the character's quad.
   * $(D_PARAM size):
   *    - x: stores the width of the character's quad in screen space.
   *    - y: stores the height of the character's quad in screen space.
   * $(D_PARAM advance):
   *    - x: stores how far in pixels the cursor should advance after adding this character on x-axis.
   *    - y: stores how far in pixels the cursor should advance after adding this character on y-axis.
  **/
  this(int id, Vector2F texCoords, Vector2F texSize, Vector2F offset, Vector2F size, Vector2F advance) {
    this.id = id;
    this.texCoords = texCoords;
    this.offset = offset;
    this.size = size;
    this.advance = advance;
    maxTexCoords = texSize + texCoords;
  }

  /**
   * Returns the ASCII value of the character.
  **/
  int getASCIIValue()   const {
    return id;
  }

  /**
   * Returns the character texture coordinates.
  **/
  Vector2F getTexCoords()   const {
    return texCoords;
  }

  /**
   * Returns the character maximum texture coordinates.
  **/
  Vector2F getMaxTexCoords()   const {
    return maxTexCoords;
  }

  /**
   * Returns the character offset.
  **/
  Vector2F getOffset()   const {
    return offset;
  }

  /**
   * Returns the dimension of the character's quad in screen space.
  **/
  Vector2F getSize()   const {
    return size;
  }

  /**
   * Returns how far in pixels the cursor should advance after adding this character.
  **/
  Vector2F getAdvance()   const {
    return advance;
  }
}