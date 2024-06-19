import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectMacroTests: XCTestCase {
    private let macros = ["Inject": InjectMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Inject var fooService: FooService
            """,
            expandedSource:
            """
            var fooService: FooService {
                get {
                    return self._fooServiceStore.value
                }
            }
            """,
            macros: self.macros
        )
    }
}
