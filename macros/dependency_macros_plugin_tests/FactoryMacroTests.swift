import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectMacroTests: XCTestCase {
    private let macros = ["Inject": InjectMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Inject
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
