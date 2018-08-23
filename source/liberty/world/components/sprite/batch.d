/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/components/sprite/batch.d, _batch.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.components.sprite.batch;

import derelict.opengl;
import liberty.core.math;
import liberty.world.components.sprite;
import liberty.graphics.vertex;
import liberty.core.utils.array : bufferSize;

class SpriteBatch {
  private {
    GLuint _vbo;
    GLuint _vao;
    SpriteGlyph[] _glyphs;
    GlyphSortType _glyphSortTypes;
    RenderBatch[] _renderBatches;
  }

  this() {

  }

  void initialize() {
    createVAO();
  }

  void begin(
    GlyphSortType glyphSortType = GlyphSortType.Texture
  ) {
    _glyphSortTypes = glyphSortType;
    _renderBatches = [];
    _glyphs = [];
  }

  void end() {
    sortGlyphs();
    createRenderBatches();
  }

  void draw(
    const ref Vector4F destRect, 
    const ref Vector4F uvRect,
    GLuint texture,
    float depth,
    const ref Color color
  ) {
    SpriteGlyph* newGlyph = new SpriteGlyph();
    
    newGlyph.texture = texture;
    newGlyph.depth = depth;

    newGlyph.topLeft.color = color;
    newGlyph.topLeft.setPosition(destRect.x, destRect.y);
    newGlyph.topLeft.setTexCoords(uvRect.x, uvRect.y);

    newGlyph.bottomLeft.color = color;
    newGlyph.bottomLeft.setPosition(destRect.x, destRect.y + destRect.w);
    newGlyph.bottomLeft.setTexCoords(uvRect.x, uvRect.y + uvRect.w);

    newGlyph.topRight.color = color;
    newGlyph.topRight.setPosition(destRect.x + destRect.z, destRect.y);
    newGlyph.topRight.setTexCoords(uvRect.x + uvRect.z, uvRect.y);

    newGlyph.bottomRight.color = color;
    newGlyph.bottomRight.setPosition(destRect.x + destRect.z, destRect.y + destRect.w);
    newGlyph.bottomRight.setTexCoords(uvRect.x + uvRect.z, uvRect.y + uvRect.w);

    import liberty.core.logger.manager : Logger;
    Logger.self.console(newGlyph.toString(), "");

    _glyphs ~= *newGlyph;
  }

  void render() {
    glBindVertexArray(_vao);
    foreach(i; 0.._renderBatches.length) {
      glBindTexture(GL_TEXTURE_2D, _renderBatches[i].texture);
      glDrawArrays(GL_TRIANGLES, _renderBatches[i].offset, _renderBatches[i].vertexCount);
    }
    glBindVertexArray(0);
  }

  void createVAO() {
    if (!_vao) {
      glGenVertexArrays(1, &_vao);
    }
    if (!_vbo) {
      glGenBuffers(1, &_vbo);
    }
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);

    // Position
    glVertexAttribPointer(
      0, 
      2,
      GL_FLOAT, 
      GL_FALSE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.position.offsetof
    );

    // Color
    glVertexAttribPointer(
      1, 
      4, 
      GL_UNSIGNED_BYTE, 
      GL_TRUE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.color.offsetof
    );

    // TexCoords
    glVertexAttribPointer(
      2, 
      2, 
      GL_FLOAT, 
      GL_TRUE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.texCoords.offsetof
    );

    glBindVertexArray(0);
  }

  void sortGlyphs() {
    import std.algorithm.sorting : sort;

    final switch (_glyphSortTypes) with (GlyphSortType) {
      case None:
        break;
      case FrontToBack:
        _glyphs.sort!("a.depth < b.depth");
        break;
      case BackToFront:
        _glyphs.sort!("a.depth > b.depth");
        break;
      case Texture:
        _glyphs.sort!("a.texture < b.texture");
        break;
    }
  }

  void createRenderBatches() {
    Vertex2[] vertices = new Vertex2[_glyphs.length * 6];

    if (!_glyphs.length) {
      return;
    }

    int offset;
    int currentVerex;
    _renderBatches ~= RenderBatch(offset, 6, _glyphs[0].texture);
    vertices[currentVerex++] = _glyphs[0].topLeft;
    vertices[currentVerex++] = _glyphs[0].bottomLeft;
    vertices[currentVerex++] = _glyphs[0].bottomRight;
    vertices[currentVerex++] = _glyphs[0].bottomRight;
    vertices[currentVerex++] = _glyphs[0].topRight;
    vertices[currentVerex++] = _glyphs[0].topLeft;
    offset += 6;
    
    foreach (currentGlyph; 1.._glyphs.length) {
      if (_glyphs[currentGlyph].texture != _glyphs[currentGlyph - 1].texture) {
        _renderBatches ~= RenderBatch(offset, 6, _glyphs[currentGlyph].texture);
      } else {
        _renderBatches[$ - 1].vertexCount += 6;
      }
      vertices[currentVerex++] = _glyphs[currentGlyph].topLeft;
      vertices[currentVerex++] = _glyphs[currentGlyph].bottomLeft;
      vertices[currentVerex++] = _glyphs[currentGlyph].bottomRight;
      vertices[currentVerex++] = _glyphs[currentGlyph].bottomRight;
      vertices[currentVerex++] = _glyphs[currentGlyph].topRight;
      vertices[currentVerex++] = _glyphs[currentGlyph].topLeft;
      offset += 6;
    }

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, vertices.bufferSize, null, GL_DYNAMIC_DRAW);
    glBufferSubData(GL_ARRAY_BUFFER, 0, vertices.bufferSize, vertices.ptr);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
  }

  private static bool compareFrontToBack(
    const ref SpriteGlyph a,
    const ref SpriteGlyph b
  ) {
    return (a.depth < b.depth);
  }

  private static bool compareBackToFront(
    const ref SpriteGlyph a,
    const ref SpriteGlyph b
  ) {
    return (a.depth > b.depth);
  }

  private static bool compareTexture(
    const ref SpriteGlyph a,
    const ref SpriteGlyph b
  ) {
    return (a.texture < b.texture);
  }
}