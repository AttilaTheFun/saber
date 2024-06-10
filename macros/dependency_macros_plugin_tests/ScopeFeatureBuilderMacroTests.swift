import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ScopeViewControllerBuilderMacroTests: XCTestCase {
    private let macros = ["ScopeViewControllerBuilder": ScopeViewControllerBuilderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @ScopeViewControllerBuilder(arguments: FooFeature.self)
            final class FooFeatureViewController: UIViewController {
            }
            """,
            expandedSource:
            """
            final class FooFeatureViewController: UIViewController {
            }

            public final class FooFeatureScopeViewControllerBuilder: DependencyContainer<FooFeatureViewControllerDependencies>, Builder {
                public func build(arguments: FooFeature) -> UIViewController {
                    return FooFeatureViewController(dependencies: self.dependencies, arguments: arguments)
                }
            }
            """,
            macros: self.macros
        )
    }
}
