"""
Defines a rule that builds a scope.
"""
load(
    "//rules/service_provider:service_provider.bzl", 
    "service_provider",
    "ServiceProviderInfo"
)
load(
    "//rules/swift_module_info_aspect:swift_module_info_aspect.bzl", 
    "swift_module_info_aspect",
    "SwiftModuleInfo"
)

def _scope_impl(ctx):
    scope_name = ctx.attr.scope_name

    # Extract the service provider infos:
    service_provider_infos = [service_provider[ServiceProviderInfo] for service_provider in ctx.attr.service_providers]

    # Extract service interfaces and implementations from the service provider infos:
    service_provider_infos = []
    service_names = []
    service_interfaces = []
    service_implementations = []
    for service_provider in ctx.attr.service_providers:
        if not ServiceProviderInfo in service_provider:
            continue
        service_provider_info = service_provider[ServiceProviderInfo]
        service_provider_infos.append(service_provider_info)
        service_names.append(service_provider_info.service_name)
        service_interfaces.append(service_provider_info.service_interface)
        service_implementations.append(service_provider_info.service_implementation)

    # Format the imports:
    all_deps = ctx.attr._base_deps + service_interfaces + service_implementations
    module_names = [dep[SwiftModuleInfo].module_name for dep in all_deps if SwiftModuleInfo in dep]
    imports = sorted(["import {}".format(module_name) for module_name in module_names])

    # Format the extensions:
    # for service_in

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = ctx.outputs.scope,
        substitutions = {
            "{imports}": "\n".join(imports),
            "{scope_name}": scope_name,
            "{extensions}": "",
        }
    )

_scope = rule(
    implementation = _scope_impl,
    attrs = {
        "scope_name": attr.string(),
        "service_providers": attr.label_list(
            providers = [ServiceProviderInfo],
        ),
        "scope": attr.output(),
        "_base_deps": attr.label_list(
            aspects = [swift_module_info_aspect],
            default = [
                "//foundations/dependency_foundation",
            ],
        ),
        "_template": attr.label(default = ":Scope.swift.tpl", allow_single_file = True),
    }
)

def scope(**kwargs):
    _scope(scope = "{scope_name}.swift".format(**kwargs), **kwargs)

