/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/file.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.file;

/**
 *
**/
final class FontFile {
  private {
    static immutable int PADDING_TOP = 0;
    static immutable int PADDING_LEFT = 1;
    static immutable int PADDING_BOTTOM = 2;
    static immutable int PADDING_RIGHT = 3;
    static immutable int DESIRED_PADDING = 3;
    static immutable string SPLITTER = " ";
    static immutable string NUMBER_SEPARATOR = ",";

    float aspectRatio;
    float verticalPerPixelSize;
    float horizontalPerPixelSize;
    float spaceWidth;
    int[] padding;
    int paddingWidth;
    int paddingHeight;
    int[char] metadata;
    string[string] values;
  }

  
}