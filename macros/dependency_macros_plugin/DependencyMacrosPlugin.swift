import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentsMacro.self,
        BuilderProviderMacro.self,
        InjectableMacro.self,
        InjectMacro.self,
        ProviderMacro.self,
        ScopeViewControllerBuilderMacro.self,
        ViewControllerBuilderMacro.self,
    ]
}
