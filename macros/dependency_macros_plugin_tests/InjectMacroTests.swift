import DependencyFoundation
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
                    if let fooService = self._fooService {
                        return fooService
                    }

                    let fooService = self._dependencies.fooService
                    self._fooService = fooService
                    return fooService
                }
            }
            """,
            macros: self.macros
        )
    }
}
