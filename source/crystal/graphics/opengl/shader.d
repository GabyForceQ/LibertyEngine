module crystal.graphics.opengl.shader;
import crystal.graphics.renderer;
import crystal.graphics.video.shader : ShaderProgram, ShaderType;
import crystal.graphics.video.backend : UnsupportedVideoFeatureException;
import crystal.graphics.opengl.vertex : GLAttribute;
import crystal.graphics.opengl.backend : GLException;
import crystal.math.vector : Vector2F, Vector3F, Vector4F;
import crystal.math.matrix: Matrix4F;
import std.string : fromStringz;
import derelict.opengl;
///
final class GLShaderProgram : ShaderProgram {
	private {
		GLAttribute[string] _activeAttributes;
	}
    /// Construct using a vertex string and a fragment string
    this(string vertex_code, string fragment_code) {
		_vertexShaderID = loadShader(vertex_code, ShaderType.Vertex);
		_fragmentShaderID = loadShader(fragment_code, ShaderType.Fragment);
		_programID = glCreateProgram();
		glAttachShader(_programID, _vertexShaderID);
        glAttachShader(_programID, _fragmentShaderID);
        //bindAttributes();
        link();
        glValidateProgram(_programID);
        //getAllUniformLocations();
    }
    ~this() {
        cleanUp();
    }
    /// Gets the linking report.
    /// Returns: Log output of the GLSL linker. Can return null!
    /// Throws: $(D GLException) on error.
    const(char)[] getLinkLog() {
        GLint logLength;
        glGetProgramiv(_programID, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength <= 0) {
            return null;
        }
        char[] log = new char[logLength + 1];
        GLint dummy;
        glGetProgramInfoLog(_programID, logLength, &dummy, log.ptr);
        GraphicsEngine.getBackend().runtimeCheck();
        return fromStringz(log.ptr);
    }
    ///
    void link() {
        glLinkProgram(_programID);
        GraphicsEngine.getBackend().runtimeCheck();
		int res;
        glGetProgramiv(_programID, GL_LINK_STATUS, &res);
        if (res != true) {
            const(char)[] linkLog = getLinkLog();
            if (linkLog != null) {
                //_gl._logger.errorf("%s", linkLog);
            }
            throw new GLException("Cannot link program");
        }
        enum SAFETY_SPACE = 128;
        // get active uniforms
        {
            GLint uniformNameMaxLength;
            glGetProgramiv(_programID, GL_ACTIVE_UNIFORM_MAX_LENGTH, &uniformNameMaxLength);
            GLchar[] buffer = new GLchar[uniformNameMaxLength + SAFETY_SPACE];
            GLint numActiveUniforms;
            glGetProgramiv(_programID, GL_ACTIVE_UNIFORMS, &numActiveUniforms);
            // get uniform block indices (if > 0, it's a block uniform)
            GLuint[] uniformIndex;
            GLint[] blockIndex;
            uniformIndex.length = numActiveUniforms;
            blockIndex.length = numActiveUniforms;
            for (GLint i = 0; i < numActiveUniforms; i++) {
                uniformIndex[i] = cast(GLuint)i;
            }
            glGetActiveUniformsiv(_programID, cast(GLint)uniformIndex.length, uniformIndex.ptr, GL_UNIFORM_BLOCK_INDEX, blockIndex.ptr);
            GraphicsEngine.getBackend().runtimeCheck();
            // get active uniform blocks
            //getUniformBlocks(this);
            //for (GLint i = 0; i < numActiveUniforms; i++) {
            //    if(blockIndex[i] >= 0) {
            //        continue;
            //    }
            //    GLint size;
            //    GLenum type;
            //    GLsizei length;
            //    glGetActiveUniform(_programID, cast(GLuint)i, cast(GLint)(buffer.length), &length, &size, &type, buffer.ptr);
            //    GraphicsEngine.getBackend().runtimeCheck();
            //    string name = fromStringz(buffer.ptr).idup;
            //   _activeUniforms[name] = new GLUniform(_programID, type, name, size);
            //}
        }
        // get active attributes
        {
            GLint attribNameMaxLength;
            glGetProgramiv(_programID, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &attribNameMaxLength);
            GLchar[] buffer = new GLchar[attribNameMaxLength + SAFETY_SPACE];
            GLint numActiveAttribs;
            glGetProgramiv(_programID, GL_ACTIVE_ATTRIBUTES, &numActiveAttribs);
            for (GLint i = 0; i < numActiveAttribs; ++i) {
                GLint size;
                GLenum type;
                GLsizei length;
                glGetActiveAttrib(_programID, cast(GLuint)i, cast(GLint)(buffer.length), &length, &size, &type, buffer.ptr);
                GraphicsEngine.getBackend().runtimeCheck();
                string name = fromStringz(buffer.ptr).idup;
                GLint location = glGetAttribLocation(_programID, buffer.ptr);
                GraphicsEngine.getBackend().runtimeCheck();
                _activeAttributes[name] = new GLAttribute(name, location, type, size);
            }
        }
    }
    ///
    GLAttribute getAttribute(string name) {
        GLAttribute* a = name in _activeAttributes;
        if (a is null) {
            _activeAttributes[name] = new GLAttribute(name);
            return _activeAttributes[name];
        }
        return *a;
    }
    ///
    //protected abstract void getAllUniformLocations();
    /// Get uniform location at specified name
    //int getUniformLocation(string uniform_name) {
    //    return glGetUniformLocation(_programID, uniform_name.ptr); // todo ?
    //}
    ///
    override uint getProgramID() {
        return _programID;
    }
    ///
    override void start() {
        glUseProgram(_programID);
    }
    ///
    override void stop() {
        glUseProgram(0);
    }
    ///
    override void cleanUp() {
        stop();
        glDetachShader(_programID, _vertexShaderID);
        glDetachShader(_programID, _fragmentShaderID);
        glDeleteShader(_vertexShaderID);
        glDeleteShader(_fragmentShaderID);
        glDeleteProgram(_programID);
    }
    ///
    override void bindAttribute(int attribute, string var_name) {
        import std.string : toStringz;
        glBindAttribLocation(_programID, attribute, var_name.toStringz);
    }
    //protected abstract void bindAttributes();
    /// Load bool uniform using location id and value.
    override void loadUniform(int locationID, bool value) {
        glUniform1i(locationID, cast(int)value);
    }
    /// Load int uniform using location id and value.
    override void loadUniform(int locationID, int value) {
        glUniform1i(locationID, value);
    }
    /// Load uint uniform using location id and value.
    override void loadUniform(int locationID, uint value) {
        glUniform1ui(locationID, value);
    }
    /// Load float uniform using location id and value.
    override void loadUniform(int locationID, float value) {
        glUniform1f(locationID, value);
    }
    /// Load Vector2F uniform using location id and value.
    override void loadUniform(int locationID, Vector2F vector) {
        glUniform2f(locationID, vector.x, vector.y);
    }
    /// Load Vector3F uniform using location id and value.
    override void loadUniform(int locationID, Vector3F vector) {
        glUniform3f(locationID, vector.x, vector.y, vector.z);
    }
    /// Load Vector4F uniform using location id and value.
	override void loadUniform(int locationID, Vector4F vector) {
        glUniform4f(locationID, vector.x, vector.y, vector.z, vector.w);
    }
    /// Load Matrix4F uniform using location id and value.
    override void loadUniform(int locationID, Matrix4F matrix) {
        //glUniform4fv(locationID, matrix.ptr); // TODO?
    }
    /// Load bool uniform using uniform name and value.
    override void loadUniform(string name, bool value) {
        glUniform1i(glGetUniformLocation(_programID, cast(const(char)*)name), cast(int)value);
    }
    /// Load int uniform using uniform name and value.
    override void loadUniform(string name, int value) {
        glUniform1i(glGetUniformLocation(_programID, cast(const(char)*)name), value);
    }
    /// Load uint uniform using uniform name and value.
    override void loadUniform(string name, uint value) {
        glUniform1ui(glGetUniformLocation(_programID, cast(const(char)*)name), value);
    }
    /// Load float uniform using uniform name and value.
    override void loadUniform(string name, float value) {
        glUniform1f(glGetUniformLocation(_programID, cast(const(char)*)name), value);
    }
    /// Load Vector2F uniform using uniform name and value.
    override void loadUniform(string name, Vector2F vector) {
        glUniform2f(glGetUniformLocation(_programID, cast(const(char)*)name), vector.x, vector.y);
    }
    /// Load Vector3F uniform using uniform name and value.
    override void loadUniform(string name, Vector3F vector) {
        glUniform3f(glGetUniformLocation(_programID, cast(const(char)*)name), vector.x, vector.y, vector.z);
    }
    /// Load Vector4F uniform using uniform name and value.
    override void loadUniform(string name, Vector4F vector) {
        glUniform4f(glGetUniformLocation(_programID, cast(const(char)*)name), vector.x, vector.y, vector.z, vector.w);
    }
    /// Load Matrix4F uniform using uniform name and value.
    override void loadUniform(string name, Matrix4F matrix) {
        glUniformMatrix4fv(glGetUniformLocation(_programID, cast(const(char)*)name), 1, GL_TRUE, matrix.ptr);
    }
    private static int loadShader(string code, ShaderType type) {
        import std.string : splitLines;
        string[] lines = splitLines(code);
        size_t lineCount = lines.length;
        auto lengths = new int[lineCount];
        auto addresses = new immutable(char)*[lineCount];
        auto localLines = new string[lineCount];
        for (size_t i = 0; i < lineCount; i++) {
            localLines[i] = lines[i] ~ "\n";
            lengths[i] = cast(int)(localLines[i].length);
            addresses[i] = localLines[i].ptr;
        }
        int shaderID;
        final switch(type) with(ShaderType) {
            case Vertex:
                shaderID = glCreateShader(GL_VERTEX_SHADER);
                break;
            case Fragment:
                shaderID = glCreateShader(GL_FRAGMENT_SHADER);
                break;
            case Geometry:
                throw new UnsupportedVideoFeatureException("Geometry shader is currently unsupported!");
            case TesselationControl:
                throw new UnsupportedVideoFeatureException("TesselationControl shader is currently unsupported!");
            case TesselationEval:
                throw new UnsupportedVideoFeatureException("TesselationEval shader is currently unsupported!");
            case Compute:
                throw new UnsupportedVideoFeatureException("Compute shader is currently unsupported!");
            case Primitive:
                throw new UnsupportedVideoFeatureException("Primitive shader is currently unsupported!");
            case Stencil:
                throw new UnsupportedVideoFeatureException("Stencil shader is currently unsupported!");
        }
        glShaderSource(shaderID, cast(int)lineCount, cast(const(char*)*)addresses.ptr, cast(const(int)*)(lengths.ptr));
        glCompileShader(shaderID);
        //int success;
        //char[512] infoLog;
        //glGetShaderiv(type, GL_COMPILE_STATUS, &success);
        //if(!success) {
        //    glGetShaderInfoLog(type, 512, null, infoLog.ptr);
        //    assert(0, "ERROR::SHADER::VERTEX::COMPILATION_FAILED:" ~ infoLog);
        //}
        return shaderID;
    }
}