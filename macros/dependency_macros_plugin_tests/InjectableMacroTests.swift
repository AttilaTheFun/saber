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
                @Factory(FooFeatureViewController.self)
                var fooFeatureFactory: Factory<FooFeature, UIViewController>

                @Factory(BarScope.self, factory: \\.barViewControllerFactory)
                var barFeatureFactory: Factory<BarFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope, FooScopeChildDependencies {
                var fooFeatureFactory: Factory<FooFeature, UIViewController> {
                    get {
                        FactoryImplementation { arguments in
                            FooFeatureViewController(arguments: arguments, dependencies: self)
                        }
                    }
                }
                var barFeatureFactory: Factory<BarFeature, UIViewController> {
                    get {
                        FactoryImplementation { arguments in
                            let scope = BarScope(arguments: arguments, dependencies: self)
                            return scope.barViewControllerFactory.build(arguments: arguments)
                        }
                    }
                }

                private let dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self.dependencies = dependencies
                    super.init()
                }
            }

            public protocol FooScopeDependencies {

            }

            public protocol FooScopeChildDependencies
                : BarScopeDependencies
                & FooFeatureViewControllerDependencies
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
                var fooService: FooService
                @Store(BarServiceImplementation.self, init: .eager, ref: .strong)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope, FooScopeChildDependencies {
                var fooService: FooService {
                    get {
                        self.weak { [unowned self] in
                            FooServiceImplementation(dependencies: self)
                        }
                    }
                }
                var barService: BarService {
                    get {
                        self.strong { [unowned self] in
                            BarServiceImplementation(dependencies: self)
                        }
                    }
                }

                private let dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self.dependencies = dependencies
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
