/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.graphics.renderer;
import crystal.math.vector : Vector2F, Vector3F;
import crystal.graphics.util : RenderUtil;
import crystal.graphics.video.vertex : VertexSpec;
import crystal.graphics.video.vao : VertexArray;
import crystal.graphics.video.buffer : VideoBuffer, BufferTarget;
import crystal.graphics.video.shader : ShaderProgram;
import derelict.opengl;
import crystal.core.imaging;
import crystal.core.engine;
import crystal.math;
import crystal.core.time;
import crystal.math.vector;
import derelict.sdl2.sdl : SDL_GL_SetSwapInterval;
import crystal.graphics.video.backend : VideoBackend;
import crystal.core.engine;
import crystal.core.model;
import crystal.graphics.material;
//import sunshine.graphics.video.vao : VertexArrayObject;
version (__OpenGL__) {
	import crystal.graphics.opengl.backend : GLBackend;
	import crystal.graphics.opengl.buffer : GLBuffer;
	//import sunshine.graphics.opengl.vao : GLVertexArrayObject;
	import derelict.opengl : glPolygonMode, GL_FRONT_AND_BACK, GL_LINE, GL_FILL;
} else version (__Vulkan__) {
	import crystal.graphics.vulkan.backend : VKBackend;
	import crystal.graphics.vulkan.buffer : VKBuffer;
} else version (__WASM__) {
		import crystal.graphics.wasm.backend : WASMBackend;
	}
///
class GraphicsEngine {
	static:
	private {
		VideoBackend _backend;
		bool _vsyncEnabled = false;
		bool _wireframe = false;
		Vector4F _color = Vector4F(1.0, 1.0, 1.0, 1.0);
	}
	void startService() {
		version (__OpenGL__) {
			_backend = new GLBackend();
		} else version (__Vulkan__) {
			_backend = new VKBackend();
		} else version (__WASM__) {
			_backend = new WASMBackend();
		}
	}
	void releaseService() {
		if (_backend !is null) {
			_backend.destroy();
			_backend = null;
		}
	}
	void restartServic() {
		releaseService();
		startService();
	}
	///
	VideoBackend getBackend() {
		return _backend;
	}
	///
	void render() {
		import derelict.opengl;
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_CULL_FACE);
		glFrontFace(GL_CW);
		_backend.resizeViewport();
		_backend.clear();
		//_backend.enableDepthTest(); // TODO. + culling.
		_backend.clearColor(_color.r, _color.g, _color.b, _color.a);
		CoreEngine.getActiveScene().render();
		_backend.swapBuffers();
	}
	///
	void setVSyncEnabled(bool enabled = true) {
		SDL_GL_SetSwapInterval(enabled); // TODO: VULKAN?
		_vsyncEnabled = enabled;
	}
	///
	bool isVSyncEnabled() nothrow {
		return _vsyncEnabled;
	}
	///
	void setWindowBackgroundColor(float r, float g, float b, float a = 1.0f) {
		_color = Vector4F(r, g, b, a);
	}
	///
	void setWindowBackgroundColor(Vector3F color, float a = 1.0f) {
		_color = Vector4F(color, a);
	}
	///
	void windowBackgroundColor(Vector4F color) {
		_color = color;
	}
	///
	void toggleWireframe() { // TODO: Vulkan.
		version (__OpenGL__) {
			if (!_wireframe) {
				glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
			} else {
				glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
			}
		}
		_wireframe = !_wireframe;
	}
}
///
static struct Vertex {
	Vector3F position;
	Vector2F texCoords;
}
///
enum Vendor : byte {
	///
	Amd = 0x00,
	///
	Intel = 0x01,
	///
	Nvidia = 0x02,
	///
	Mesa = 0x03,
	/// For Software rendering, no driver
	Apple = 0x04,
	/// For GDI Generic, no driver
	Microsoft = 0x05,
	///
	Other = -0x01
}
version (__Lite__) {
} else {
	/// Number of elements of Vendor enumeration (!LiteVersion)
	enum VendorCount = __traits(allMembers, Vendor).length;
}
///
enum Blending : byte {
	///
	Opaque = 0x00,
	///
	AlphaBlend = 0x01,
	///
	NonPremultiplied = 0x02,
	///
	Additive = 0x03
}
///
enum Sampling : byte {
	///
	AnisotropicClamp = 0x00,
	///
	AnisotropicWrap = 0x01,
	///
	LinearClamp = 0x02,
	///
	LinearWrap = 0x03,
	///
	PointClamp = 0x04,
	///
	PointWrap = 0x05
}
///
enum VSyncState : byte {
	///
	Immediate = 0x00,
	///
	Default = 0x01,
	///
	LateTearing = -0x01
	// TODO: GSync / FreeSync ?
}
///
enum DataUsage : byte {
	///
	StreamDraw = 0x00,
	///
	StreamRead = 0x01,
	///
	StreamCopy = 0x02,
	///
	StaticDraw = 0x03,
	///
	StaticRead = 0x04,
	///
	StaticCopy = 0x05,
	///
	DynamicDraw = 0x06,
	///
	DynamicRead = 0x07,
	///
	DynamicCopy = 0x08
}
///
enum DrawMode : byte {
	///
	Triangles = 0x00
}
///
enum VectorType : byte {
	///
	UnsignedInt = 0x00
}
///
interface Renderable {
	///
	void render();
}
