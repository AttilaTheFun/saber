import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ProvideMacroTests: XCTestCase {
    private let macros = ["Provide": ProvideMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Provide var user: User
            """,
            expandedSource:
            """
            var user: User
            """,
            macros: self.macros
        )
    }
}
