/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/util.d, _util.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.util;
import liberty.graphics.renderer : DataUsage, DrawMode, VectorType;
import liberty.graphics.video.backend : VideoBackend;
import liberty.graphics.video.buffer : VideoBuffer, BufferTarget;
import liberty.graphics.video.vao : VertexArray;
import liberty.graphics.video.shader : ShaderProgram;
import liberty.graphics.video.vertex : VertexSpec;
import liberty.core.utils : Singleton;
import derelict.opengl;
version (__OpenGL__) {
	import liberty.graphics.opengl.backend : GLBackend;
	import liberty.graphics.opengl.buffer : GLBuffer;
	import liberty.graphics.opengl.vao : GLVertexArray;
	import liberty.graphics.opengl.shader : GLShaderProgram;
	import liberty.graphics.opengl.vertex : GLVertexSpec;
} else version (__Vulkan__) {
	import liberty.graphics.vulkan.backend : VKBackend;
	import liberty.graphics.vulkan.buffer : VKBuffer;
} else version (__WASM__) {
	import liberty.graphics.wasm.backend : WASMBackend;
}
///
final class RenderUtil : Singleton!RenderUtil {
	///
    VideoBuffer createBuffer(T)(BufferTarget target, DataUsage usage, T[] data = null) {
        uint _target, _usage;
        VideoBuffer buff = null;
        version (__OpenGL__) {
            final switch(target) with (BufferTarget) {
                case Array: _target = GL_ARRAY_BUFFER; break;
                case AtomicCounter: _target = GL_ATOMIC_COUNTER_BUFFER; break;
                case CopyRead: _target = GL_COPY_READ_BUFFER; break;
                case CopyWrite: _target = GL_COPY_WRITE_BUFFER; break;
                case DispatchIndirect: _target = GL_DISPATCH_INDIRECT_BUFFER; break;
                case DrawIndirect: _target = GL_DRAW_INDIRECT_BUFFER; break;
                case ElementArray: _target = GL_ELEMENT_ARRAY_BUFFER; break;
                case PixelPack: _target = GL_PIXEL_PACK_BUFFER; break;
                case PixelUnpack: _target = GL_PIXEL_UNPACK_BUFFER; break;
                case Query: _target = GL_QUERY_BUFFER; break;
                case ShaderStorage: _target = GL_SHADER_STORAGE_BUFFER; break;
                case Texture: _target = GL_TEXTURE_BUFFER; break;
                case TransformFeedback: _target = GL_TRANSFORM_FEEDBACK_BUFFER; break;
                case Uniform: _target = GL_UNIFORM_BUFFER; break;
            }
            final switch(usage) with (DataUsage) {
                case StreamDraw: _usage = GL_STREAM_DRAW; break;
                case StreamRead: _usage = GL_STREAM_READ; break;
                case StreamCopy: _usage = GL_STREAM_COPY; break;
                case StaticDraw: _usage = GL_STATIC_DRAW; break;
                case StaticRead: _usage = GL_STATIC_READ; break;
                case StaticCopy: _usage = GL_STATIC_COPY; break;
                case DynamicDraw: _usage = GL_DYNAMIC_DRAW; break;
                case DynamicRead: _usage = GL_DYNAMIC_READ; break;
                case DynamicCopy: _usage = GL_DYNAMIC_COPY; break;
            }
            if (data is null) {
                buff = new GLBuffer(_target, _usage);
            } else {
                buff = new GLBuffer(_target, _usage, data);
            }
        } else version (__Vulkan__) {
            if (data is null) {
                buff = new VKBuffer(_target, _usage);
            } else {
	            buff = new VKBuffer(_target, _usage, data);
	        }
        } else {
            throw new UnsupportedVideoFeatureException("createBuffer() -> VideoBuffer");
        }
        return buff;
    }
    ///
    VertexArray createVertexArray() {
        VertexArray vao = null;
        version (__OpenGL__) {
            vao = new GLVertexArray();
        } else version (__Vulkan__) {
            vao = new VKVertexArray();
        } else {
            throw new UnsupportedVideoFeatureException("createVertexArray() -> VertexArray");
        }
        return vao;
    }
    ///
    ShaderProgram createShaderProgram(string vertex_code, string fragment_code) {
        ShaderProgram shader = null;
        version (__OpenGL__) {
            shader = new GLShaderProgram(vertex_code, fragment_code);
        } else version (__Vulkan__) {
            shader = new VKShaderProgram(vertex_code, fragment_code);
        } else {
            throw new UnsupportedVideoFeatureException("createShader() -> ShaderProgram");
        }
        return shader;
    }
    ///
    VertexSpec!VERTEX createVertexSpec(VERTEX)(ShaderProgram shader_program) {
        VertexSpec!VERTEX vertex_spec = null;
        version (__OpenGL__) {
            vertex_spec = new GLVertexSpec!VERTEX(cast(GLShaderProgram)shader_program);
        } else version (__Vulkan__) {
            vertex_spec = new VKVertexSpec!VERTEX(cast(VKShaderProgram)shader_program);
        } else {
            throw new UnsupportedVideoFeatureException("createVertexSpec() -> VertexSpec");
        }
        return vertex_spec;
    }
    ///
    void drawElements(DrawMode drawMode, int count, VectorType type) @trusted {
        version (__OpenGL__) {
            GLenum _drawMode, _type;
            final switch (drawMode) with (DrawMode) {
                case Triangles: _drawMode = GL_TRIANGLES;
            }
            final switch (type) with (VectorType) {
                case UnsignedInt: _type = GL_UNSIGNED_INT;
            }
            glDrawElements(_drawMode, count, _type, cast(void*)0);
        } else version (__Vulkan__) {
            // TODO.
        } else {
            throw new UnsupportedVideoFeatureException("drawElements()");
        }
    }
}