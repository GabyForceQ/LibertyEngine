/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/package.d, _package.d)
 * Documentation:
 * Coverage:
 */
// TODO: Get rid of derelict.opengl import.
module liberty.graphics.opengl;
version (__OpenGL__) :
version (__NoDefaultImports__) {
} else {
    public {
        import derelict.opengl;
        import liberty.graphics.opengl.backend;
        import liberty.graphics.opengl.buffer;
        //import liberty.graphics.opengl.fbo;
        //import liberty.graphics.opengl.renderbuffer;
        import liberty.graphics.opengl.shader;
        import liberty.graphics.opengl.texture;
        import liberty.graphics.opengl.traits;
        //import liberty.graphics.opengl.uniform;
        import liberty.graphics.opengl.vao;
        import liberty.graphics.opengl.vertex;
    }
}