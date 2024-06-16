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

    func testAll() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope {
                @Arguments var fooArguments: FooArguments
                @Inject var fooService: FooService
                @Factory(FooViewController.self) var fooViewControllerFactory: Factory<FooArguments, UIViewController>
                @Store(BarServiceImplementation.self) var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var fooArguments: FooArguments {
                    get {
                        return self._arguments
                    }
                }
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.building
                    }
                }
                var fooViewControllerFactory: Factory<FooArguments, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.building
                        return FactoryImplementation { [childDependencies] arguments in
                            FooViewController(arguments: arguments, dependencies: childDependencies)
                        }
                    }
                }
                var barService: BarService {
                    get {
                        return self._barServiceStore.building
                    }
                }

                private let _arguments: FooArguments

                private lazy var _fooServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.fooService
                    }
                )

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return BarServiceImplementation(dependencies: self._childDependenciesStore.building)
                    }
                )

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _dependencies: any FooScopeDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooScopeDependencies
                ) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
                var fooService: FooService {
                    get
                }
            }

            fileprivate class FooScopeChildDependencies: FooScopeDependencies, BarServiceImplementationDependencies, FooViewControllerDependencies {
                private let _parent: FooScope
                fileprivate var fooArguments: FooArguments {
                    return self._parent.fooArguments
                }
                fileprivate var fooService: FooService {
                    return self._parent.fooService
                }
                fileprivate var fooViewControllerFactory: Factory<FooArguments, UIViewController> {
                    return self._parent.fooViewControllerFactory
                }
                fileprivate var barService: BarService {
                    return self._parent.barService
                }
                fileprivate init(parent: FooScope ) {
                    self._parent = parent
                }
            }
            """,
            macros: self.macros
        )
    }

    func testInject() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope {
                @Inject var fooService: FooService
                @Inject(storage: .weak) var barService: BarService
                @Inject(storage: .computed) var bazService: BazService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.building
                    }
                }
                var barService: BarService {
                    get {
                        return self._barServiceStore.building
                    }
                }
                var bazService: BazService {
                    get {
                        return self._bazServiceStore.building
                    }
                }

                private lazy var _fooServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.fooService
                    }
                )

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.barService
                    }
                )

                private lazy var _bazServiceStore = StoreImplementation(
                    backingStore: ComputedBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.bazService
                    }
                )

                private let _dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
                var fooService: FooService {
                    get
                }
                var barService: BarService {
                    get
                }
                var bazService: BazService {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }

    func testArguments() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope {
                @Arguments var fooArguments: FooArguments
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var fooArguments: FooArguments {
                    get {
                        return self._arguments
                    }
                }

                private let _arguments: FooArguments

                private let _dependencies: any FooScopeDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooScopeDependencies
                ) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {

            }
            """,
            macros: self.macros
        )
    }

    func testFactory() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope: FooScopeChildDependencies {
                @Factory(FooFeatureViewController.self)
                public var fooFeatureFactory: Factory<FooFeature, UIViewController>

                @Factory(BarScope.self, factory: \\.barViewControllerFactory)
                public var barFeatureFactory: Factory<BarFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: FooScopeChildDependencies {
                public var fooFeatureFactory: Factory<FooFeature, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.building
                        return FactoryImplementation { [childDependencies] arguments in
                            FooFeatureViewController(arguments: arguments, dependencies: childDependencies)
                        }
                    }
                }
                public var barFeatureFactory: Factory<BarFeature, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.building
                        return FactoryImplementation { [childDependencies] arguments in
                            let concrete = BarScope(arguments: arguments, dependencies: childDependencies)
                            return concrete.barViewControllerFactory.build(arguments: arguments)
                        }
                    }
                }

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {

            }

            fileprivate class FooScopeChildDependencies: FooScopeDependencies, BarScopeDependencies, FooFeatureViewControllerDependencies {
                private let _parent: FooScope
                fileprivate var fooFeatureFactory: Factory<FooFeature, UIViewController> {
                    return self._parent.fooFeatureFactory
                }
                fileprivate var barFeatureFactory: Factory<BarFeature, UIViewController> {
                    return self._parent.barFeatureFactory
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }
            """,
            macros: self.macros
        )
    }

    func testStore() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope: FooScopeChildDependencies {
                @Store(FooServiceImplementation.self, init: .eager) 
                var fooService: FooService

                @Store(BarServiceImplementation.self, storage: .weak)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope: FooScopeChildDependencies {
                
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.building
                    }
                }
                var barService: BarService {
                    get {
                        return self._barServiceStore.building
                    }
                }

                private lazy var _fooServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooServiceImplementation(dependencies: self._childDependenciesStore.building)
                    }
                )

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return BarServiceImplementation(dependencies: self._childDependenciesStore.building)
                    }
                )

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _dependencies: any FooScopeDependencies

                public init(
                    dependencies: any FooScopeDependencies
                ) {
                    self._dependencies = dependencies
                    _ = self.fooService
                }
            }

            public protocol FooScopeDependencies: AnyObject {

            }

            fileprivate class FooScopeChildDependencies: FooScopeDependencies, BarServiceImplementationDependencies, FooServiceImplementationDependencies {
                private let _parent: FooScope
                fileprivate var fooService: FooService {
                    return self._parent.fooService
                }
                fileprivate var barService: BarService {
                    return self._parent.barService
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }
            """,
            macros: self.macros
        )
    }

    func testViewController() throws {
        assertMacroExpansion(
            """
            @Injectable(.viewController)
            public final class FooViewController: UIViewController {
                @Arguments private var fooArguments: FooArguments
                @Inject private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooViewController: UIViewController {
                private var fooArguments: FooArguments {
                    get {
                        return self._arguments
                    }
                }
                private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get {
                        return self._loggedInFeatureFactoryStore.building
                    }
                }

                private let _arguments: FooArguments

                private lazy var _loggedInFeatureFactoryStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.loggedInFeatureFactory
                    }
                )

                private let _dependencies: any FooViewControllerDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooViewControllerDependencies
                ) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    super.init(nibName: nil, bundle: nil)
                }

                required init?(coder: NSCoder) {
                    fatalError("not implemented")
                }
            }

            public protocol FooViewControllerDependencies: AnyObject {
                var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }

    func testView() throws {
        assertMacroExpansion(
            """
            @Injectable(.view)
            public final class FooView: UIView {
                @Arguments private var fooArguments: FooArguments
                @Inject private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooView: UIView {
                private var fooArguments: FooArguments {
                    get {
                        return self._arguments
                    }
                }
                private var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get {
                        return self._loggedInFeatureFactoryStore.building
                    }
                }

                private let _arguments: FooArguments

                private lazy var _loggedInFeatureFactoryStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.loggedInFeatureFactory
                    }
                )

                private let _dependencies: any FooViewDependencies

                public init(
                    arguments: FooArguments,
                    dependencies: any FooViewDependencies
                ) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    super.init(frame: .zero)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }

            public protocol FooViewDependencies: AnyObject {
                var loggedInFeatureFactory: any Factory<LoggedInFeature, UIViewController> {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }

    func testService() throws {
        assertMacroExpansion(
            """
            @Injectable(.unowned)
            public final class FooServiceImplementation {
                @Inject private var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooServiceImplementation {
                private var barService: BarService {
                    get {
                        return self._barServiceStore.building
                    }
                }

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return self._dependencies.barService
                    }
                )

                private unowned let _dependencies: any FooServiceImplementationDependencies

                public init(
                    dependencies: any FooServiceImplementationDependencies
                ) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooServiceImplementationDependencies: AnyObject {
                var barService: BarService {
                    get
                }
            }
            """,
            macros: self.macros
        )
    }
}
