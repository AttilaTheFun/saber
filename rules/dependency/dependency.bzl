
def _dependency_impl(ctx):
    pass

dependency = rule(
    implementation = _dependency_impl,
    attrs = {
        "interface": attr.label(),
        
    }
)