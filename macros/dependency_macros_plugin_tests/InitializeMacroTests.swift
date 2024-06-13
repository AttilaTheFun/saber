import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InitializeMacroTests: XCTestCase {
    private let macros = ["Initialize": InitializeMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Initialize
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
