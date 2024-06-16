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
                    let childDependencies = self._childDependenciesStore.building
                    return FactoryImplementation { [childDependencies] arguments in
                        FooFeatureViewController(arguments: arguments, dependencies: childDependencies)
                    }
                }
            }
            var barFeatureFactory: Factory<BarFeature, UIViewController> {
                get {
                    let childDependencies = self._childDependenciesStore.building
                    return FactoryImplementation { [childDependencies] arguments in
                        let concrete = BarScope(arguments: arguments, dependencies: childDependencies)
                        return concrete.barViewControllerFactory.build(arguments: arguments)
                    }
                }
            }
            """,
            macros: self.macros
        )
    }
}
