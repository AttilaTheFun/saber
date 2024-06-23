import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class FulfillMacroTests: XCTestCase {
    private let macros = ["Fulfill": FulfillMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Fulfill(BarServiceImplementationUnownedDependencies.self)
            lazy var barService: any BarService = BarServiceImplementation(dependencies: self.fulfilledDependencies)
            """,
            expandedSource:
            """
            lazy var barService: any BarService = BarServiceImplementation(dependencies: self.fulfilledDependencies)
            """,
            macros: self.macros
        )
    }
}
