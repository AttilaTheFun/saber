import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ScopeViewControllerBuilderMacroTests: XCTestCase {
    private let macros = ["ScopeViewControllerBuilder": ScopeViewControllerBuilderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @ScopeViewControllerBuilder(arguments: FooFeature.self)
            final class FooScope: Scope<FooScopeDependencies> {
            }
            """,
            expandedSource:
            """
            final class FooScope: Scope<FooScopeDependencies> {
            }

            public final class FooScopeBuilder: DependencyContainer<FooScopeDependencies>, Builder {
                public func build(arguments: FooFeature) -> UIViewController {
                    let scope = FooScope(dependencies: self.dependencies, arguments: arguments)
                    return scope.fooFeatureViewControllerBuilder.build(arguments: arguments)
                }
            }
            """,
            macros: self.macros
        )
    }
}
