import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BuilderProviderMacro.self,
        ProviderMacro.self,
        ScopeViewControllerBuilderMacro.self,
        ViewControllerBuilderMacro.self,
    ]
}
