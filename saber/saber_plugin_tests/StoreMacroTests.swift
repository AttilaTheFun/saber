import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class StoreMacroTests: XCTestCase {
    private let macros = ["Store": StoreMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Store(FooServiceImplementation.self) var fooService: FooService
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