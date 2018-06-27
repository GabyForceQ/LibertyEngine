/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.graphics.video.vao;
///
abstract class VertexArray {
	protected {
        uint _handle;
        bool _initialized;
    }
    ///
    void bind();
    ///
    void unbind();
    ///
    uint handle();
}