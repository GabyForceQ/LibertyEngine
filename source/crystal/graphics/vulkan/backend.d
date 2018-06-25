module crystal.graphics.vulkan.backend;
version (__Vulkan__) :
import crystal.core.engine;
import crystal.graphics.common.backend : VideoBackend;
/// The one exception type thrown in this wrapper.
/// A failing Vulkan function should <b>always</b> throw an $(D VKException).
class VKException : Exception {
    ///
    @safe pure nothrow this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}
///
final class VKBackend : VideoBackend {

}