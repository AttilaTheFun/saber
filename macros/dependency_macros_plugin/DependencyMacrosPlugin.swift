import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentsMacro.self,
        FactoryMacro.self,
        InjectableMacro.self,
        InjectMacro.self,
        InitializeMacro.self,
        InstantiateMacro.self,
        ScopeViewControllerBuilderMacro.self,
        ScopeInjectableMacro.self,
        StoreMacro.self,
        ViewControllerBuilderMacro.self,
        ViewControllerInjectableMacro.self,
    ]
}
