/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// TODO: Get rid of derelict.opengl import.
module crystal.graphics.opengl;
version (__OpenGL__) :
version (__NoDefaultImports__) {
} else {
    public {
        import derelict.opengl;
        import crystal.graphics.opengl.backend;
        import crystal.graphics.opengl.buffer;
        //import crystal.graphics.opengl.fbo;
        //import crystal.graphics.opengl.renderbuffer;
        import crystal.graphics.opengl.shader;
        import crystal.graphics.opengl.texture;
        import crystal.graphics.opengl.traits;
        //import crystal.graphics.opengl.uniform;
        import crystal.graphics.opengl.vao;
        import crystal.graphics.opengl.vertex;
    }
}