import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Injectable": InjectableMacro.self,
        "ViewControllerInjectable": ViewControllerInjectableMacro.self,
        "Arguments": ArgumentsMacro.self,
        "Inject": InjectMacro.self,
    ]

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
                let fooArguments: FooArguments
                let fooService: FooService
                let barService: BarService

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
                let fooArguments: FooArguments

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
                let fooService: FooService
                let barService: BarService

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

    func testWithViewController() throws {
        assertMacroExpansion(
            """
            @ViewControllerInjectable
            public final class FooViewController: UIViewController {
                @Arguments private let fooArguments: FooArguments
                @Inject private let fooService: FooService
                @Inject private let barService: BarService
                @Inject private let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooViewController: UIViewController {
                private let fooArguments: FooArguments
                private let fooService: FooService
                private let barService: BarService
                private let loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController>

                private let dependencies: any FooViewControllerDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: some FooViewControllerDependencies
                ) {
                    self.fooArguments = arguments
                    self.dependencies = dependencies
                    self.fooService = dependencies.fooService
                    self.barService = dependencies.barService
                    self.loggedInFeatureBuilder = dependencies.loggedInFeatureBuilder
                    super.init(nibName: nil, bundle: nil)
                }

                required init?(coder: NSCoder) {
                    fatalError("not implemented")
                }
            }

            public protocol FooViewControllerDependencies {
                var fooService: FooService {
                    get
                }
                var barService: BarService {
                    get
                }
                var loggedInFeatureBuilder: any Builder<LoggedInFeature, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
