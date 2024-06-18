import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ArgumentsMacroTests: XCTestCase {
    private let macros = ["Arguments": ArgumentsMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Arguments var fooArguments: FooArguments
            """,
            expandedSource:
            """
            var fooArguments: FooArguments {
                get {
                    return self._arguments
                }
            }
            """,
            macros: self.macros
        )
    }
}
