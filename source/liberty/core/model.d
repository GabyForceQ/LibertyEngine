/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model.d, _model.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.model;
import liberty.graphics.util : RenderUtil;
import liberty.graphics.video.vertex : VertexSpec;
import liberty.graphics.video.vao : VertexArray;
import liberty.graphics.video.buffer : VideoBuffer, BufferTarget;
import liberty.graphics.material : Material, Materials;
import liberty.graphics.renderer : Vertex, DataUsage;
import liberty.math : Vector2F, Vector3F;
import liberty.core.utils : Singleton;
///
struct Mesh {
	///
	VertexArray vao;
	///
    VideoBuffer vbo;
    ///
    VideoBuffer ibo;
    ///
    void clear() {
        vao.destroy();
        vbo.destroy();
        ibo.destroy();
    }
}
///
final class Model(VERTEX) {
	private {
		VertexSpec!VERTEX _vertexSpec;
		Mesh _mesh;
		Material _material;
	}
	///
	this(VERTEX[] vboArray, uint[] indices, Material material = Materials.get.defaultMaterial) {
		_material = material;
		_vertexSpec = RenderUtil.get.createVertexSpec!VERTEX(_material.shader);
        _mesh.vao = RenderUtil.get.createVertexArray();
        _mesh.vbo = RenderUtil.get.createBuffer(BufferTarget.Array, DataUsage.StaticDraw, vboArray[]);
        _mesh.ibo = RenderUtil.get.createBuffer(BufferTarget.ElementArray, DataUsage.StaticDraw);
        _mesh.vao.bind();
        _mesh.vbo.bind();
        _mesh.ibo.data = indices;
        _vertexSpec.use();
        _mesh.vao.unbind();
	}
	///
	~this() {
		_mesh.clear();
		_vertexSpec.destroy();
	}
	///
	Mesh mesh() {
		return _mesh;
	}
	///
	Material material() {
		return _material;
	}
	///
	void mesh(Mesh mesh) pure nothrow {
		_mesh = mesh;
	}
	///
	void material(Material material) pure nothrow {
		_material = material;
	}
}
///
final class Models : Singleton!Models {
	///
	Model!Vertex rectangleModel;
	///
	Model!Vertex cubeModel;
	///
	void load() {
		/* Create rectangleModel */
		Vertex[4] rectangleVertices;
		rectangleVertices[0] = Vertex(Vector3F( 0.5f,  0.5f, 0.0f), Vector2F(1.0f, 1.0f));
        rectangleVertices[1] = Vertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector2F(1.0f, 0.0f));
        rectangleVertices[2] = Vertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector2F(0.0f, 0.0f));
        rectangleVertices[3] = Vertex(Vector3F(-0.5f,  0.5f, 0.0f), Vector2F(0.0f, 1.0f));
		uint[] rectangleIndices = [
			0, 1, 3,
			1, 2, 3
		];
		rectangleModel = new Model!Vertex(rectangleVertices, rectangleIndices);
		/* Create cubeModel */
		Vertex[8] cubeVertices;
		cubeVertices[0] = Vertex(Vector3F(-0.5, -0.5, -0.5), Vector2F(0, 0));
        cubeVertices[1] = Vertex(Vector3F(0.5, -0.5, -0.5), Vector2F(1, 0));
        cubeVertices[2] = Vertex(Vector3F(0.5, 0.5, -0.5), Vector2F(1, 1));
        cubeVertices[3] = Vertex(Vector3F(-0.5, 0.5, -0.5), Vector2F(0, 1));
        cubeVertices[4] = Vertex(Vector3F(-0.5, -0.5, 0.5), Vector2F(0, 1));
        cubeVertices[5] = Vertex(Vector3F(0.5, -0.5, 0.5), Vector2F(1, 0));
        cubeVertices[6] = Vertex(Vector3F(0.5, 0.5, 0.5), Vector2F(0, 0));
        cubeVertices[7] = Vertex(Vector3F(-0.5, 0.5, 0.5), Vector2F(1, 1));
		uint[] cubeIndices = [
	         0, 1, 3, 3, 1, 2,
	         1, 5, 2, 2, 5, 6,
	         5, 4, 6, 6, 4, 7,
	         4, 0, 7, 7, 0, 3,
	         3, 2, 7, 7, 2, 6,
	         4, 5, 0, 0, 5, 1
	     ];
        cubeModel = new Model!Vertex(cubeVertices, cubeIndices);
	}
}