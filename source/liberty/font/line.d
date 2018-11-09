/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/line.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.line;

import liberty.font.word;

/**
 * Represents a line of text.
**/
final class Line {
  private {
    // getLineLength
    float lineLength = 0.0f;
    // getMaxLength
    float maxLength;
    // getSpaceSize
    float spaceSize;
    // getWords
    Word[] words;
  }

  /**
   *
  **/
  this(float spaceWidth, float fontSize, float maxLength) {
    this.spaceSize = spaceWidth * fontSize;
    this.maxLength = maxLength;
  }
}