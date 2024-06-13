import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentsMacro.self,
        InjectableMacro.self,
        InjectMacro.self,
        InstantiateMacro.self,
        ScopeViewControllerBuilderMacro.self,
        ScopeInjectableMacro.self,
        ViewControllerBuilderMacro.self,
        ViewControllerInjectableMacro.self,
    ]
}
