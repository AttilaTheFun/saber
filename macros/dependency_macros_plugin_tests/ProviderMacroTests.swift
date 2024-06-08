import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ProviderMacroTests: XCTestCase {
    private let macros = ["Provider": ProviderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Provider
            protocol FooService {}
            """,
            expandedSource:
            """
            protocol FooService {}

            protocol FooServiceProvider {
                var fooService: FooService {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
