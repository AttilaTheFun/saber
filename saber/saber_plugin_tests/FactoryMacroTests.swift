import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class FactoryMacroTests: XCTestCase {
    private let macros = ["Factory": FactoryMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Factory(FooViewController.self)
            var fooViewControllerFactory: Factory<Void, UIViewController>

            @Factory(BarScope.self, factory: \\.rootFactory)
            var barViewControllerFactory: Factory<BarScopeArguments, UIViewController>
            """,
            expandedSource:
            """
            var fooViewControllerFactory: Factory<Void, UIViewController> {
                get {
                    Factory { arguments in
                        FooViewController(arguments: arguments, dependencies: self)
                    }
                }
            }
            var barViewControllerFactory: Factory<BarScopeArguments, UIViewController> {
                get {
                    Factory { arguments in
                        let concrete = BarScope(arguments: arguments, dependencies: self)
                        return concrete.rootFactory.build(arguments: arguments)
                    }
                }
            }
            """,
            macros: self.macros
        )
    }
}
