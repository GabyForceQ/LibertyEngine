/**
* Module Author: Gabriel Gheorghe
* Last Modified: Version 0.0.1 (alpha)
*/
module crystal.core.model;
import crystal.graphics.util: RenderUtil;
import crystal.graphics.video.vertex: VertexSpec;
import crystal.graphics.video.vao: VertexArray;
import crystal.graphics.video.buffer: VideoBuffer, BufferTarget;
import crystal.graphics.material: Material, Materials;
import crystal.graphics.renderer: Vertex, DataUsage;
import crystal.math: Vector2F, Vector3F;
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
	this(VERTEX[] vboArray, uint[] indices, Material material = Materials.defaultMaterial) {
		_material = material;
		_vertexSpec = RenderUtil.createVertexSpec!VERTEX(_material.getShader());
        _mesh.vao = RenderUtil.createVertexArray();
        _mesh.vbo = RenderUtil.createBuffer(BufferTarget.Array, DataUsage.StaticDraw, vboArray[]);
        _mesh.ibo = RenderUtil.createBuffer(BufferTarget.ElementArray, DataUsage.StaticDraw);
        _mesh.vao.bind();
        _mesh.vbo.bind();
        _mesh.ibo.setData(indices);
        _vertexSpec.use();
        _mesh.vao.unbind();
	}
	///
	~this() {
		_mesh.clear();
		_vertexSpec.destroy();
	}
	///
	Mesh getMesh() {
		return _mesh;
	}
	///
	Material getMaterial() {
		return _material;
	}
	///
	void setMesh(Mesh mesh) pure nothrow {
		_mesh = mesh;
	}
	///
	void setMaterial(Material material) pure nothrow {
		_material = material;
	}
}
///
final class Models {
	static:
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