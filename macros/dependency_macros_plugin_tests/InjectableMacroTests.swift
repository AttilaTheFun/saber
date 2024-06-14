import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Injectable": InjectableMacro.self,

        "Arguments": ArgumentsMacro.self,
        "Inject": InjectMacro.self,
        "Factory": FactoryMacro.self,
        "Store": StoreMacro.self,

        // TODO: Delete and just support through @Injectable + looking at inheritance clause.
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

    func testWithFactory() throws {
        assertMacroExpansion(
            """
            @ScopeInjectable
            public final class FooScope: Scope, FooScopeChildDependencies {
                @Factory(FooServiceImplementation.self)
                let fooServiceType: FooService.Type
                @Factory(FooViewController.self, arguments: FooFeature.self)
                let fooViewControllerType: UIViewController.Type
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope, FooScopeChildDependencies {
                let fooServiceType: FooService.Type
                let fooViewControllerType: UIViewController.Type

                private let dependencies: any FooScopeDependencies

                public var fooServiceFactory: any Factory<Void, FooService> {
                    FactoryImplementation<Void, FooService> { arguments in
                        FooServiceImplementation(dependencies: self)
                    }
                }

                public var fooViewControllerFactory: any Factory<FooFeature, UIViewController> {
                    FactoryImplementation<FooFeature, UIViewController> { arguments in
                        FooViewController(arguments: arguments, dependencies: self)
                    }
                }

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self.dependencies = dependencies
                    self.fooServiceType = FooServiceImplementation.self
                    self.fooViewControllerType = FooViewController.self
                    super.init()
                }
            }

            public protocol FooScopeDependencies {

            }

            public protocol FooScopeChildDependencies
                : FooServiceImplementationDependencies
                & FooViewControllerDependencies
            {
            }
            """,
            macros: self.macros
        )
    }

    func testWithStore() throws {
        assertMacroExpansion(
            """
            @ScopeInjectable
            public final class FooScope: Scope, FooScopeChildDependencies {
                @Store(FooServiceImplementation.self, init: .lazy, ref: .weak)
                let fooServiceType: FooService.Type
                @Store(BarServiceImplementation.self, init: .eager, ref: .strong)
                let barServiceType: BarService.Type
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope, FooScopeChildDependencies {
                let fooServiceType: FooService.Type
                let barServiceType: BarService.Type

                private let dependencies: any FooScopeDependencies

                public var fooService: any FooService {
                    self.weak { [unowned self] in
                        FooServiceImplementation(dependencies: self)
                    }
                }

                public var barService: any BarService {
                    self.strong { [unowned self] in
                        BarServiceImplementation(dependencies: self)
                    }
                }

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self.dependencies = dependencies
                    self.fooServiceType = FooServiceImplementation.self
                    self.barServiceType = BarServiceImplementation.self
                    super.init()
                    _ = self.barService
                }
            }

            public protocol FooScopeDependencies {

            }

            public protocol FooScopeChildDependencies
                : BarServiceImplementationDependencies
                & FooServiceImplementationDependencies
            {
            }
            """,
            macros: self.macros
        )
    }

    func testWithScope() throws {
        assertMacroExpansion(
            """
            @ScopeInjectable
            public final class FooScope: Scope {
                @Arguments private let fooArguments: FooArguments
                @Inject private let fooService: FooService
                @Inject private let barService: BarService
                @Inject private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope {
                private let fooArguments: FooArguments
                private let fooService: FooService
                private let barService: BarService
                private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

                private let dependencies: any FooScopeDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooScopeDependencies
                ) {
                    self.fooArguments = arguments
                    self.dependencies = dependencies
                    self.fooService = dependencies.fooService
                    self.barService = dependencies.barService
                    self.loggedInFeatureFactory = dependencies.loggedInFeatureFactory
                    super.init()
                }
            }

            public protocol FooScopeDependencies {
                var fooService: FooService {
                    get
                }
                var barService: BarService {
                    get
                }
                var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
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
                @Inject private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooViewController: UIViewController {
                private let fooArguments: FooArguments
                private let fooService: FooService
                private let barService: BarService
                private let loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>

                private let dependencies: any FooViewControllerDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooViewControllerDependencies
                ) {
                    self.fooArguments = arguments
                    self.dependencies = dependencies
                    self.fooService = dependencies.fooService
                    self.barService = dependencies.barService
                    self.loggedInFeatureFactory = dependencies.loggedInFeatureFactory
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
                var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
