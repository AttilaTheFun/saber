import SaberPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest

final class OnceMacroTests: XCTestCase {
    private let macros = ["Once": OnceMacro.self]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @Once
            lazy var userService: any UserService = self.userServiceOnce { [unowned self] in
                UserServiceImplementation(dependencies: self.fulfilledDependencies)
            }
            """,
            expandedSource:
            """
            lazy var userService: any UserService = self.userServiceOnce { [unowned self] in
                UserServiceImplementation(dependencies: self.fulfilledDependencies)
            }

            private let userServiceOnce = Once<any UserService>()
            """,
            macros: self.macros
        )
    }
}
