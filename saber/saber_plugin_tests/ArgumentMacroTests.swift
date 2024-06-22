import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ArgumentMacroTests: XCTestCase {
    private let macros = ["Argument": ArgumentMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Argument var user: User
            """,
            expandedSource:
            """
            var user: User {
                get {
                    return self.arguments.user
                }
            }
            """,
            macros: self.macros
        )
    }
}
