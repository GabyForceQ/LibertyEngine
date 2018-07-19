/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/renderer.d, _renderer.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.engine;
import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.graphics.util : RenderUtil;
import liberty.graphics.video.vertex : VertexSpec;
import liberty.graphics.video.vao : VertexArray;
import liberty.graphics.video.buffer : VideoBuffer, BufferTarget;
import liberty.graphics.video.shader : ShaderProgram;
import derelict.opengl;
import liberty.core.imaging;
import liberty.core.engine;
import liberty.core.math;
import liberty.core.time;
import liberty.core.math.vector;
import derelict.sdl2.sdl : SDL_GL_SetSwapInterval;
import liberty.graphics.video.backend : VideoBackend;
import liberty.core.engine;
import liberty.core.model;
import liberty.graphics.material;
import liberty.core.utils : Singleton;
import liberty.core.logger : Logger;
//import sunshine.graphics.video.vao : VertexArrayObject;
version (__OpenGL__) {
	import liberty.graphics.opengl.backend : GLBackend;
	import liberty.graphics.opengl.buffer : GLBuffer;
	//import sunshine.graphics.opengl.vao : GLVertexArrayObject;
	import derelict.opengl : glPolygonMode, GL_FRONT_AND_BACK, GL_LINE, GL_FILL;
} else version (__Vulkan__) {
	import liberty.graphics.vulkan.backend : VKBackend;
	import liberty.graphics.vulkan.buffer : VKBuffer;
} else version (__WASM__) {
		import liberty.graphics.wasm.backend : WASMBackend;
	}
///
final class GraphicsEngine : Singleton!GraphicsEngine {
	private {
		bool _serviceRunning;
		VideoBackend _backend;
		bool _vsyncEnabled;
		bool _wireframe;
		Vector4F _color = Vector4F(1.0, 1.0, 1.0, 1.0);
	}
	/// Start GraphicsEngine service.
	void startService() @trusted {
		version (__OpenGL__) {
			_backend = new GLBackend();
			Logger.get.info("GraphicsEngine service started with OpenGL backend.", this);
		} else version (__Vulkan__) {
			_backend = new VKBackend();
			Logger.get.info("GraphicsEngine service started with Vulkan backend.", this);
		} else version (__WASM__) {
			_backend = new WASMBackend();
		}
		_serviceRunning = true;
	}
	/// Stop GraphicsEngine service.
	void stopService() @trusted {
		if (_backend !is null) {
			_backend.destroy();
			_backend = null;
		}
		_serviceRunning = false;
		Logger.get.info("GraphicsEngine service stopped.", this);
	}
	///  Restart GraphicsEngine service.
	void restartService() @trusted {
		stopService();
		startService();
	}
	/// Returns true if GraphicsEngine service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
	///
	VideoBackend backend() pure nothrow @safe @nogc {
		return _backend;
	}
	///
	void render() @trusted {
		import derelict.opengl : glEnable, glFrontFace, GL_DEPTH_TEST, GL_CULL_FACE, GL_CW;
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_CULL_FACE);
		glFrontFace(GL_CW);
		_backend.resizeViewport();
		_backend.clear();
		//_backend.enableDepthTest(); // TODO. + culling.
		_backend.clearColor(_color.r, _color.g, _color.b, _color.a);
		CoreEngine.get.activeScene.render();
		_backend.swapBuffers();
	}
	///
	void vSyncEnabled(bool enabled = true) nothrow @trusted @nogc {
		SDL_GL_SetSwapInterval(enabled); // TODO: VULKAN?
		_vsyncEnabled = enabled;
	}
	///
	bool isVSyncEnabled() pure nothrow const @safe @nogc {
		return _vsyncEnabled;
	}
	///
	void windowBackgroundColor(Vector4F color) pure nothrow @safe @nogc @property {
		_color = color;
	}
	///
	void toggleWireframe() @trusted { // TODO: Vulkan.
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
static struct Vertex(ubyte T) if (T == 2 || T == 3) {
	static if (T == 2) {
		///
		Vector3F position;
		///
		Vector2F texCoords;
	} else static if (T == 3) {
		///
		Vector3F position;
		///
		Vector2F texCoords;
	}
}
///
alias Vertex2 = Vertex!2;
///
alias Vertex3 = Vertex!3;
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
interface IRenderable {
	///
	void render();
}
