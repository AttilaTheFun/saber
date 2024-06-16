import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ArgumentsMacroTests: XCTestCase {
    private let macros = ["Arguments": ArgumentsMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Arguments var fooFeature: FooFeature
            """,
            expandedSource:
            """
            var fooFeature: FooFeature {
                get {
                    return self._arguments
                }
            }
            """,
            macros: self.macros
        )
    }
}
