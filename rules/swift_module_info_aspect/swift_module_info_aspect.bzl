"""
Defines an aspect that provides information about the Swift module built by a swift_library target.
"""


SwiftModuleInfo = provider(
    doc = "Provides information about the Swift module built by a swift_library target.",
    fields = {
        "module_name": "The name of the Swift module."
    }
)

def _swift_module_info_aspect_impl(_, aspect_ctx):
    if aspect_ctx.rule.kind == "swift_library" and hasattr(aspect_ctx.rule.attr, "module_name"):
        return [SwiftModuleInfo(module_name = aspect_ctx.rule.attr.module_name)]

    return []

swift_module_info_aspect = aspect(
    implementation = _swift_module_info_aspect_impl,
    attrs = {}
)