import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ArgumentsMacroTests: XCTestCase {
    private let macros = ["Arguments": ArgumentsMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Arguments
            let fooFeature: FooFeature
            """,
            expandedSource:
            """
            let fooFeature: FooFeature
            """,
            macros: self.macros
        )
    }
}
