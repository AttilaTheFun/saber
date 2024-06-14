import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentsMacro.self,
        FactoryMacro.self,
        InjectMacro.self,
        StoreMacro.self,

        InjectableMacro.self,
        ViewControllerInjectableMacro.self,
    ]
}
