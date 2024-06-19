import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentMacro.self,
        FactoryMacro.self,
        InjectableMacro.self,
        InjectMacro.self,
        StoreMacro.self,
    ]
}
