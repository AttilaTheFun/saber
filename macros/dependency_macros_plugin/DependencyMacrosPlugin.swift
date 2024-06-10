import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentsMacro.self,
        BuilderProviderMacro.self,
        ProviderMacro.self,
        ScopeViewControllerBuilderMacro.self,
        ViewControllerBuilderMacro.self,
    ]
}
