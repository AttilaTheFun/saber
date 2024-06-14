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
            @Inject(access: .weak) var barService: BarService
            @Inject(access: .strong) var bazService: BazService
            """,
            expandedSource:
            """
            var fooService: FooService {
                get {
                    return self._dependencies.fooService
                }
            }
            var barService: BarService {
                get {
                    if let barService = self._barService {
                        return barService
                    }

                    let barService = self._dependencies.barService
                    self._barService = barService
                    return barService
                }
            }
            var bazService: BazService {
                get {
                    if let bazService = self._bazService {
                        return bazService
                    }

                    let bazService = self._dependencies.bazService
                    self._bazService = bazService
                    return bazService
                }
            }
            """,
            macros: self.macros
        )
    }
}
