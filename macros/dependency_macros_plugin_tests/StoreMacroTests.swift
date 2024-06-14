import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class StoreMacroTests: XCTestCase {
    private let macros = ["Store": StoreMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Store(FooFeatureViewControllerImplementation.swift)
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
