import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ViewControllerBuilderMacroTests: XCTestCase {
    private let macros = ["ViewControllerBuilder": ViewControllerBuilderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @ViewControllerBuilder(arguments: FooFeature.self)
            final class FooFeatureViewController: UIViewController {
            }
            """,
            expandedSource:
            """
            final class FooFeatureViewController: UIViewController {
            }

            public final class FooFeatureViewControllerBuilder: DependencyContainer<FooFeatureViewControllerDependencies>, Builder {
                public func build(arguments: FooFeature) -> UIViewController {
                    return FooFeatureViewController(arguments: arguments, dependencies: self.dependencies)
                }
            }
            """,
            macros: self.macros
        )
    }
}
