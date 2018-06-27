/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.graphics.postprocessing;
version (nonde) :
version (__OpenGL__) :
import crystal.graphics.opengl;
/// Value less = priority bigger
enum PostProcessFxFlag : long {
	///
	Default = 0x00,
	///
	Sepia = 0x01,
	///
    Aqua = 0x02, // TODO.
	///
	BlackAndWhite = 0x04
}
///
class Postprocessing {
	private immutable defaultVER = "
		#version 450 core
	";
	private immutable defaultVS = "
		#if VERTEX_SHADER
            in vec3 position;
            in vec2 coordinates;
            out vec2 fragmentUV;
            void main()
            {
                gl_Position = vec4(position, 1.0);
                fragmentUV = coordinates;
            }
        #endif
	";
	private immutable defaultFS_begin = "
		#if FRAGMENT_SHADER
            in vec2 fragmentUV;
            uniform sampler2D fbTexture;
            out vec4 color;
            void main() {
                vec3 base = texture(fbTexture, fragmentUV).rgb;
	";
	private immutable defaultFS_end = "
		        color = vec4(base, 1.0);
            }
        #endif
	";
	private immutable bwFS = "
                float luminance = base.r * 0.299 + base.g * 0.578 + base.b * 0.114;
                base = vec3(luminance);
	";
	private immutable sepiaFS = "
				vec3 sepia = vec3(
					clamp(base.r * 0.393 + base.g * 0.769 + base.b * 0.189, 0.0, 1.0),
					clamp(base.r * 0.349 + base.g * 0.686 + base.b * 0.168, 0.0, 1.0),
					clamp(base.r * 0.272 + base.g * 0.534 + base.b * 0.131, 0.0, 1.0)
				);
				base = mix(base, sepia, clamp(1.0, 0.0, 1.0));
    ";
	///
    this(GLBackend gl, int screenWidth, int screenHeight, PostProcessFxFlag flag) {
        _screenBuf = new GLTexture2D();
        _screenBuf.setMinFilter(GL_LINEAR_MIPMAP_LINEAR);
        _screenBuf.setMagFilter(GL_LINEAR);
        _screenBuf.setWrapS(GL_CLAMP_TO_EDGE);
        _screenBuf.setWrapT(GL_CLAMP_TO_EDGE);
        _screenBuf.setImage(0, GL_RGBA, screenWidth, screenHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
        _screenBuf.generateMipmap();
        _fbo = new GLFrameBufferObject();
        _fbo.use();
        _fbo.color(0).attach(_screenBuf);
        _fbo.unuse();

        // create a shader program made of a single fragment shader
        string postprocProgramSource = defaultVER ~ defaultVS ~ defaultFS_begin;
        if (flag & PostProcessFxFlag.Sepia) {
            postprocProgramSource ~= sepiaFS;
        }
        if (flag & PostProcessFxFlag.BlackAndWhite) {
            postprocProgramSource ~= bwFS;
        }
        postprocProgramSource ~= defaultFS_end;
            
        _program = new GLProgram(postprocProgramSource);
    }

    ~this()
    {
        _program.destroy();
        _fbo.destroy();
        _screenBuf.destroy();
    }

    void bindFBO()
    {
        _fbo.use();
    }

    // Post-processing pass
    void pass(void delegate() drawGeometry) {
        _fbo.unuse();
        _screenBuf.generateMipmap();

        int texUnit = 1;
        _screenBuf.use(texUnit);

        _program.uniform("fbTexture").set(texUnit);
        _program.uniform("sharpen").set(true);
        _program.use();

        drawGeometry();
    }
private:
    GLFrameBufferObject _fbo;
    GLTexture2D _screenBuf;
    GLProgram _program;
}