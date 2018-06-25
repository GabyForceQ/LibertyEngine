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