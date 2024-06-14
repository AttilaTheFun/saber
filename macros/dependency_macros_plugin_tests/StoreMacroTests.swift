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
            var fooFeature: FooFeature
            """,
            expandedSource:
            """
            var fooFeature: FooFeature {
                get {
                    self.strong { [unowned self] in
                        FooFeatureViewControllerImplementation.swift(dependencies: self)
                    }
                }
            }
            """,
            macros: self.macros
        )
    }
}
