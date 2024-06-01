"""
Defines a rule that provides a service.
"""

load(
    "//rules/swift_module_info_aspect:swift_module_info_aspect.bzl", 
    "swift_module_info_aspect"
)

ServiceProviderInfo = provider(
    doc = "",
    fields = {
        "service_name":"",
        "service_interface":"",
        "service_implementation":"",
    }
)

def _service_provider_impl(ctx):
    return ServiceProviderInfo(
        service_name = ctx.attr.service_name,
        service_interface = ctx.attr.service_interface,
        service_implementation = ctx.attr.service_implementation,
    )

service_provider = rule(
    implementation = _service_provider_impl,
    attrs = {
        "service_name": attr.string(),
        "service_interface": attr.label(
            aspects = [swift_module_info_aspect],
        ),
        "service_implementation": attr.label(
            aspects = [swift_module_info_aspect],
        ),
    }
)