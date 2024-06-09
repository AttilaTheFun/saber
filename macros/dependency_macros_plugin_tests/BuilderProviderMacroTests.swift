import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class BuilderProviderMacroTests: XCTestCase {
    private let macros = ["BuilderProvider": BuilderProviderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @BuilderProvider(UIViewController.self)
            public struct Foo {}
            """,
            expandedSource:
            """
            public struct Foo {}

            public protocol FooBuilderProvider {
                var fooBuilder: any Builder<Foo, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
