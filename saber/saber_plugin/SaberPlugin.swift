import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SaberPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArgumentMacro.self,
        FactoryMacro.self,
        FulfillMacro.self,
        InjectableMacro.self,
        InjectMacro.self,
        ScopeMacro.self,
        StoreMacro.self,
    ]
}
