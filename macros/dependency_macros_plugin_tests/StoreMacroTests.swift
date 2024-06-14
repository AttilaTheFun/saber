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
                    if let fooFeature = self._fooFeature {
                        return fooFeature
                    }

                    let fooFeature = FooFeatureViewControllerImplementation.swift(dependencies: self)
                    self._fooFeature = fooFeature
                    return fooFeature
                }
            }
            """,
            macros: self.macros
        )
    }
}
