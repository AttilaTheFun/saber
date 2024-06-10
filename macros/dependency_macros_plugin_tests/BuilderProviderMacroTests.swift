import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class BuilderProviderMacroTests: XCTestCase {
    private let macros = ["BuilderProvider": BuilderProviderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @BuilderProvider
            public struct FooFeature {}
            """,
            expandedSource:
            """
            public struct FooFeature {}

            public protocol FooFeatureBuilderProvider {
                var fooFeatureBuilder: any Builder<FooFeature, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
