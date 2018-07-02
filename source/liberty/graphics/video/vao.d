/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/video/vao.d, _vao.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.vao;
///
abstract class VertexArray {
	protected {
        uint _handle;
        bool _initialized;
    }
    ///
    void bind() @trusted;
    ///
    void unbind() @trusted;
    ///
    uint handle();
}