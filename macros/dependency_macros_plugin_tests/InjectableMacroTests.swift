import DependencyMacrosPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Argument": ArgumentMacro.self,
        "Factory": FactoryMacro.self,
        "Injectable": InjectableMacro.self,
        "Inject": InjectMacro.self,
        "Store": StoreMacro.self,
    ]

    func testArgument() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class Foo {
                @Argument var user: User
            }
            """,
            expandedSource:
            """
            public final class Foo {
                var user: User {
                    get {
                        return self._arguments.user
                    }
                }

                public typealias Arguments = FooArguments

                public typealias Dependencies = FooDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooDependencies: AnyObject {
            }

            extension Foo: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testFactory() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope: Scope<FooViewControllerArguments, UIViewController> {
                @Factory(FooViewController.self)
                public var rootFactory: Factory<FooViewControllerArguments, UIViewController>

                @Factory(BarScope.self, factory: \\.rootFactory)
                public var barViewControllerFactory: Factory<BarViewControllerArguments, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope<FooViewControllerArguments, UIViewController> {
                public var rootFactory: Factory<FooViewControllerArguments, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.value
                        return FactoryImplementation { [childDependencies] arguments in
                            FooViewController(arguments: arguments, dependencies: childDependencies)
                        }
                    }
                }
                public var barViewControllerFactory: Factory<BarViewControllerArguments, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.value
                        return FactoryImplementation { [childDependencies] arguments in
                            let concrete = BarScope(arguments: arguments, dependencies: childDependencies)
                            return concrete.rootFactory.build(arguments: arguments)
                        }
                    }
                }

                public typealias Arguments = FooViewControllerArguments

                public typealias Dependencies = FooScopeDependencies

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            fileprivate class FooScopeChildDependencies: FooScope.Dependencies, FooViewController.Dependencies, BarScope.Dependencies {
                private let _parent: FooScope
                fileprivate var rootFactory: Factory<FooViewControllerArguments, UIViewController> {
                    return self._parent.rootFactory
                }
                fileprivate var barViewControllerFactory: Factory<BarViewControllerArguments, UIViewController> {
                    return self._parent.barViewControllerFactory
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }

            extension FooScope: Injectable {
            }
            """,
            macros: self.macros
        )
    }


    func testInject() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooObject {
                @Inject var fooService: FooService
                @Inject(storage: .weak) var barService: BarService
                @Inject(storage: .computed) var bazService: BazService
            }
            """,
            expandedSource:
            """
            public final class FooObject {
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.value
                    }
                }
                var barService: BarService {
                    get {
                        return self._barServiceStore.value
                    }
                }
                var bazService: BazService {
                    get {
                        return self._bazServiceStore.value
                    }
                }

                public typealias Arguments = Void

                public typealias Dependencies = FooObjectDependencies

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

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooObjectDependencies: AnyObject {
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

            extension FooObject: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testStore() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooObject {
                @Store(FooServiceImplementation.self, init: .eager)
                var fooService: FooService

                @Store(BarServiceImplementation.self, storage: .weak)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooObject {
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.value
                    }
                }
                var barService: BarService {
                    get {
                        return self._barServiceStore.value
                    }
                }

                public typealias Arguments = Void

                public typealias Dependencies = FooObjectDependencies

                private lazy var _fooServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooServiceImplementation(dependencies: self._childDependenciesStore.value)
                    }
                )

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return BarServiceImplementation(dependencies: self._childDependenciesStore.value)
                    }
                )

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooObjectChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    _ = self.fooService
                }
            }

            public protocol FooObjectDependencies: AnyObject {
            }

            fileprivate class FooObjectChildDependencies: FooObject.Dependencies, FooServiceImplementation.UnownedDependencies, BarServiceImplementation.Dependencies {
                private let _parent: FooObject
                fileprivate var fooService: FooService {
                    return self._parent.fooService
                }
                fileprivate var barService: BarService {
                    return self._parent.barService
                }
                fileprivate init(parent: FooObject) {
                    self._parent = parent
                }
            }

            extension FooObject: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testViewController() throws {
        assertMacroExpansion(
            """
            @Injectable(UIViewController.self)
            public final class FooViewController: ParentViewController {
            }
            """,
            expandedSource:
            """
            public final class FooViewController: ParentViewController {

                public typealias Arguments = Void

                public typealias Dependencies = FooViewControllerDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    super.init(nibName: nil, bundle: nil)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }

            public protocol FooViewControllerDependencies: AnyObject {
            }

            extension FooViewController: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testView() throws {
        assertMacroExpansion(
            """
            @Injectable(UIView.self)
            public final class FooView: ParentView {
            }
            """,
            expandedSource:
            """
            public final class FooView: ParentView {

                public typealias Arguments = Void

                public typealias Dependencies = FooViewDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    super.init(frame: .zero)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }

            public protocol FooViewDependencies: AnyObject {
            }

            extension FooView: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testUnownedDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable(dependencies: .unowned)
            public final class FooServiceImplementation {
            }
            """,
            expandedSource:
            """
            public final class FooServiceImplementation {

                public typealias Arguments = Void

                public typealias UnownedDependencies = FooServiceImplementationUnownedDependencies

                private let _arguments: Arguments

                private unowned let _dependencies: any UnownedDependencies

                public init(arguments: Arguments, dependencies: UnownedDependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooServiceImplementationUnownedDependencies: AnyObject {
            }

            extension FooServiceImplementation: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testArgumentsTypeInferredFromScopeArguments() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooScope: Scope<FooViewControllerArguments, UIViewController> {
                @Factory(FooViewController.self)
                var rootFactory: any Factory<FooViewControllerArguments, UIViewController>

                @Factory(FooDetailsViewController.self)
                var fooDetailsViewControllerFactory: any Factory<Void, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope: Scope<FooViewControllerArguments, UIViewController> {
                var rootFactory: any Factory<FooViewControllerArguments, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.value
                        return FactoryImplementation { [childDependencies] arguments in
                            FooViewController(arguments: arguments, dependencies: childDependencies)
                        }
                    }
                }
                var fooDetailsViewControllerFactory: any Factory<Void, UIViewController> {
                    get {
                        let childDependencies = self._childDependenciesStore.value
                        return FactoryImplementation { [childDependencies] arguments in
                            FooDetailsViewController(arguments: arguments, dependencies: childDependencies)
                        }
                    }
                }

                public typealias Arguments = FooViewControllerArguments

                public typealias Dependencies = FooScopeDependencies

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            fileprivate class FooScopeChildDependencies: FooScope.Dependencies, FooViewController.Dependencies, FooDetailsViewController.Dependencies {
                private let _parent: FooScope
                fileprivate var rootFactory: any Factory<FooViewControllerArguments, UIViewController> {
                    return self._parent.rootFactory
                }
                fileprivate var fooDetailsViewControllerFactory: any Factory<Void, UIViewController> {
                    return self._parent.fooDetailsViewControllerFactory
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }

            extension FooScope: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testArgumentsTypeInferredVoid() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class Foo {
            }
            """,
            expandedSource:
            """
            public final class Foo {

                public typealias Arguments = Void

                public typealias Dependencies = FooDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooDependencies: AnyObject {
            }

            extension Foo: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testHandWrittenInitializer() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class Foo {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    print("hand written initializer")
                }
            }
            """,
            expandedSource:
            """
            public final class Foo {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    print("hand written initializer")
                }

                public typealias Arguments = Void

                public typealias Dependencies = FooDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies
            }

            public protocol FooDependencies: AnyObject {
            }

            extension Foo: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testHandWrittenDependenciesTypeAlias() throws {
        assertMacroExpansion(
            """
            public protocol FooSpecialDependencies {
            }

            @Injectable
            public final class Foo {
                public typealias Dependencies = FooSpecialDependencies
            }
            """,
            expandedSource:
            """
            public protocol FooSpecialDependencies {
            }
            public final class Foo {
                public typealias Dependencies = FooSpecialDependencies

                public typealias Arguments = Void

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            extension Foo: Injectable {
            }
            """,
            macros: self.macros
        )
    }

    func testHandWrittenArgumentsTypeAlias() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class Foo {
                public typealias Arguments = FooSpecialArguments
            }
            """,
            expandedSource:
            """
            public final class Foo {
                public typealias Arguments = FooSpecialArguments

                public typealias Dependencies = FooDependencies

                private let _arguments: Arguments

                private let _dependencies: any Dependencies

                public init(arguments: Arguments, dependencies: Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooDependencies: AnyObject {
            }

            extension Foo: Injectable {
            }
            """,
            macros: self.macros
        )
    }
}
