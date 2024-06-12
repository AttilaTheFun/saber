import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacrosTestSupport
import XCTest


final class InjectableMacroTests: XCTestCase {
    private let macros = ["Injectable": InjectableMacro.self]

    func testWithArgumentsAndDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScopeImplementation {
                @Arguments let fooArguments: FooArguments
                @Inject let fooService: FooService
                @Inject let barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScopeImplementation {
                @Arguments let fooArguments: FooArguments
                @Inject let fooService: FooService
                @Inject let barService: BarService

                private let dependencies: any FooScopeImplementationDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: some FooScopeImplementationDependencies
                ) {
                    self.fooArguments = arguments
                    self.dependencies = dependencies
                    self.fooService = dependencies.fooService
                    self.barService = dependencies.barService
                }
            }

            public protocol FooScopeImplementationDependencies {
                var fooService: FooService {
                    get
                }
                var barService: BarService {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }

    func testWithArguments() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScopeImplementation {
                @Arguments let fooArguments: FooArguments
            }
            """,
            expandedSource:
            """
            public final class FooScopeImplementation {
                @Arguments let fooArguments: FooArguments

                private let dependencies: any FooScopeImplementationDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: some FooScopeImplementationDependencies
                ) {
                    self.fooArguments = arguments
                    self.dependencies = dependencies
                }
            }

            public protocol FooScopeImplementationDependencies {

            }
            """,
            macros: self.macros
        )
    }

    func testWithDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScopeImplementation {
                @Inject let fooService: FooService
                @Inject let barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScopeImplementation {
                @Inject let fooService: FooService
                @Inject let barService: BarService

                private let dependencies: any FooScopeImplementationDependencies

                public init(
                    dependencies: some FooScopeImplementationDependencies
                ) {
                    self.dependencies = dependencies
                    self.fooService = dependencies.fooService
                    self.barService = dependencies.barService
                }
            }

            public protocol FooScopeImplementationDependencies {
                var fooService: FooService {
                    get
                }
                var barService: BarService {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
