import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class FactoryMacroTests: XCTestCase {
    private let macros = ["Factory": FactoryMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Factory(FooFeatureViewController.self)
            var fooFeatureFactory: Factory<FooFeature, UIViewController>

            @Factory(BarScope.self, factory: \\.barViewControllerFactory)
            var barFeatureFactory: Factory<BarFeature, UIViewController>
            """,
            expandedSource:
            """
            var fooFeatureFactory: Factory<FooFeature, UIViewController> {
                get {
                    FactoryImplementation { arguments in
                        FooFeatureViewController(arguments: arguments, dependencies: self)
                    }
                }
            }
            var barFeatureFactory: Factory<BarFeature, UIViewController> {
                get {
                    FactoryImplementation { arguments in
                        let scope = BarScope(arguments: arguments, dependencies: self)
                        return scope.barViewControllerFactory.build(arguments: arguments)
                    }
                }
            }
            """,
            macros: self.macros
        )
    }
}
