import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import DependencyMacrosLibrary

public class InjectableMacro: InjectableMacroProtocol {}

public final class ViewControllerInjectableMacro: InjectableMacroProtocol {
    public static func superclassInitializerLine() -> String? {
        return "super.init(nibName: nil, bundle: nil)"
    }

    public static func requiredInitializers() -> [DeclSyntax] {
        return [
            """
            required init?(coder: NSCoder) {
                fatalError("not implemented")
            }
            """
        ]
    }
}

public final class ScopeInjectableMacro: InjectableMacroProtocol {

    // TODO: Get rid of DependencyContainer superclass.
    public static func superclassInitializerLine() -> String? {
        return "super.init(dependencies: dependencies)"
    }
}
