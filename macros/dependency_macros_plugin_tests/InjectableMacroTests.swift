import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Instantiate": InstantiateMacro.self, // TODO: Delete

        "Arguments": ArgumentsMacro.self,
        "Inject": InjectMacro.self,
        "Initialize": InitializeMacro.self,

        "Injectable": InjectableMacro.self,
        "ViewControllerInjectable": ViewControllerInjectableMacro.self,
        "ScopeInjectable": ScopeInjectableMacro.self,
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
                    dependencies: any FooScopeImplementationDependencies
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
                    dependencies: any FooScopeImplementationDependencies
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
                    dependencies: any FooScopeImplementationDependencies
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

    func testWithInitialize() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScopeImplementation {
                @Initialize(FooServiceImplementation.self)
                let fooServiceType: FooService.Type
                @Initialize(FooViewController.self, arguments: FooFeature.self)
                let fooViewControllerType: UIViewController.Type
            }
            """,
            expandedSource:
            """
            public final class FooScopeImplementation {
                let fooServiceType: FooService.Type
                let fooViewControllerType: UIViewController.Type

                private let dependencies: any FooScopeImplementationDependencies

                public init(
                    dependencies: any FooScopeImplementationDependencies
                ) {
                    self.dependencies = dependencies
                    self.fooServiceType = FooServiceImplementation.self
                    self.fooViewControllerType = FooViewController.self
                }

                private func initializeFooService() -> any FooService {
                    return FooServiceImplementation(dependencies: self)
                }

                private func initializeFooViewController() -> any UIViewController {
                    return FooViewController(dependencies: self)
                }
            }

            public protocol FooScopeImplementationDependencies {

            }

            public protocol FooScopeImplementationChildDependencies
                : FooServiceImplementationDependencies
                & FooViewControllerDependencies
            {
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
                    dependencies: any FooViewControllerDependencies
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
