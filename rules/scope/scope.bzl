
def _scope_impl(ctx):
    pass

scope = rule(
    implementation = _scope_impl,
    attrs = {
        "parent": attr.label(),
        
    }
)