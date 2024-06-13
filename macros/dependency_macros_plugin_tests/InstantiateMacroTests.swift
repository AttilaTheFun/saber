import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InstantiateMacroTests: XCTestCase {
    private let macros = ["Instantiate": InstantiateMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Instantiate
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
