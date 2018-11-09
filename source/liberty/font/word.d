/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/word.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.word;

import liberty.font.character;

/**
 * Represents one word in the text.
**/
final class Word {
  private {
    Character[] characters;
    float width = 0.0f;
    float fontSize;
  }

  /**
   * Create a new empty word.
   * $(D_PARAM fontSize):
   *    - the font size of the text which this word is in.
  **/
  this(float fontSize) pure nothrow {
    this.fontSize = fontSize;
  }

  /**
   * Add a new character to the end of the current word.
   * It increases the width of the word.
   * $(D_PARAM character):
   *    - the character to be added.
  **/
  Word addCharacter(Character character) pure nothrow {
    characters ~= character;
    width += character.getAdvance().x * fontSize;
    return this;
  }

  /**
   * Returns the list of characters in the word.
  **/
  Character[] getCharacters() pure nothrow {
    return characters;
  }

  /**
   * Returns the width of the word relative to screen size.
  **/
  float getWidth() pure nothrow const {
    return width;
  }
}