import DependencyFoundation
import DependencyMacrosPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Arguments": ArgumentsMacro.self,
        "Factory": FactoryMacro.self,
        "Inject": InjectMacro.self,
        "Injectable": InjectableMacro.self,
        "Store": StoreMacro.self,
    ]

    func testWithArgumentsAndDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope {
                @Arguments let fooArguments: FooArguments
                @Inject var fooService: FooService
                @Inject var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                let fooArguments: FooArguments
                var fooService: FooService {
                    get {
                        return self._dependencies.fooService
                    }
                }
                var barService: BarService {
                    get {
                        return self._dependencies.barService
                    }
                }

                private let _dependencies: any FooScopeDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooScopeDependencies
                ) {
                    self.fooArguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies {
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
            public final class FooScope {
                @Arguments let fooArguments: FooArguments
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                let fooArguments: FooArguments

                private let _dependencies: any FooScopeDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooScopeDependencies
                ) {
                    self.fooArguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies {

            }
            """,
            macros: self.macros
        )
    }

    func testWithDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope {
                @Inject var fooService: FooService
                @Inject var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var fooService: FooService {
                    get {
                        return self._dependencies.fooService
                    }
                }
                var barService: BarService {
                    get {
                        return self._dependencies.barService
                    }
                }

                private let _dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies {
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
            @Injectable
            public final class FooScope: FooScopeChildDependencies {
                @Factory(FooFeatureViewController.self)
                var fooFeatureFactory: Factory<FooFeature, UIViewController>

                @Factory(BarScope.self, factory: \\.barViewControllerFactory)
                var barFeatureFactory: Factory<BarFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: FooScopeChildDependencies {
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

                private let _dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
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
            @Injectable
            public final class FooScope: FooScopeChildDependencies {
                @Store(FooServiceImplementation.self, thread: .unsafe)
                var fooService: FooService

                @Store(BarServiceImplementation.self, init: .eager)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope: FooScopeChildDependencies {
                var fooService: FooService {
                    get {
                        let fooService: FooService
                        if let _fooService = self._fooService {
                            fooService = _fooService
                        } else {
                            fooService = FooServiceImplementation(dependencies: self)
                        }
                        return fooService
                    }
                }
                var barService: BarService {
                    get {
                        self._barServiceLock.lock()
                        defer {
                            self._barServiceLock.unlock()
                        }
                        let barService: BarService
                        if let _barService = self._barService {
                            barService = _barService
                        } else {
                            barService = BarServiceImplementation(dependencies: self)
                        }
                        return barService
                    }
                }

                private let _dependencies: any FooScopeDependencies

                private var _fooService: FooService?

                private var _barService: BarService?

                private var _barServiceLock = Lock()

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
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

    func testWithViewController() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooViewController: UIViewController {
                @Arguments private let fooArguments: FooArguments
                @Inject private var fooService: FooService
                @Inject private var barService: BarService
                @Inject private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooViewController: UIViewController {
                private let fooArguments: FooArguments
                private var fooService: FooService {
                    get {
                        return self._dependencies.fooService
                    }
                }
                private var barService: BarService {
                    get {
                        return self._dependencies.barService
                    }
                }
                private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get {
                        return self._dependencies.loggedInFeatureFactory
                    }
                }

                private let _dependencies: any FooViewControllerDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooViewControllerDependencies
                ) {
                    self.fooArguments = arguments
                    self._dependencies = dependencies
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
