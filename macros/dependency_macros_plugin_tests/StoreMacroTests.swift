import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class StoreMacroTests: XCTestCase {
    private let macros = ["Store": StoreMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Store(FooServiceImplementation.swift)
            var fooService: FooService
            """,
            expandedSource:
            """
            var fooService: FooService {
                get {
                    self._fooServiceLock.lock()
                    defer {
                        self._fooServiceLock.unlock()
                    }
                    let fooService: FooService
                    if let _fooService = self._fooService {
                        fooService = _fooService
                    } else {
                        fooService = FooServiceImplementation.swift(dependencies: self)
                    }
                    return fooService
                }
            }
            """,
            macros: self.macros
        )
    }
}
