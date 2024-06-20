import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class FactoryMacroTests: XCTestCase {
    private let macros = ["Factory": FactoryMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Factory(FooViewController.self)
            var fooViewControllerFactory: Factory<FooFeature, UIViewController>

            @Factory(BarScope.self, factory: \\.rootFactory)
            var barViewControllerFactory: Factory<BarFeature, UIViewController>
            """,
            expandedSource:
            """
            var fooViewControllerFactory: Factory<FooFeature, UIViewController> {
                get {
                    let childDependencies = self._childDependenciesStore.value
                    return FactoryImplementation { [childDependencies] arguments in
                        FooViewController(arguments: arguments, dependencies: childDependencies)
                    }
                }
            }
            var barViewControllerFactory: Factory<BarFeature, UIViewController> {
                get {
                    let childDependencies = self._childDependenciesStore.value
                    return FactoryImplementation { [childDependencies] arguments in
                        let concrete = BarScope(arguments: arguments, dependencies: childDependencies)
                        return concrete.rootFactory.build(arguments: arguments)
                    }
                }
            }
            """,
            macros: self.macros
        )
    }
}
