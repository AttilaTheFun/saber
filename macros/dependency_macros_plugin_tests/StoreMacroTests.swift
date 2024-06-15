import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class StoreMacroTests: XCTestCase {
    private let macros = ["Store": StoreMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Store(FooServiceImplementation.self)
            var fooService: FooService
            """,
            expandedSource:
            """
            var fooService: FooService {
                get {
                    if let fooService = self._fooService {
                        return fooService
                    }
                    self._fooServiceLock.lock()
                    defer {
                        self._fooServiceLock.unlock()
                    }
                    if let fooService = self._fooService {
                        return fooService
                    }
                    let fooService = FooServiceImplementation(dependencies: self)
                    self._fooService = fooService
                    return fooService
                }
            }
            """,
            macros: self.macros
        )
    }
}
