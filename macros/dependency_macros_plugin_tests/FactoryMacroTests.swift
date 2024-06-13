import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class FactoryBuilderMacroTests: XCTestCase {
    private let macros = ["FactoryBuilder": FactoryBuilderMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @FactoryBuilder(FooFeatureViewControllerImplementation.swift)
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
