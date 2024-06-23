import SaberPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ScopeMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Argument": ArgumentMacro.self,
        "Factory": FactoryMacro.self,
        "Injectable": InjectableMacro.self,
        "Inject": InjectMacro.self,
        "Provide": ProvideMacro.self,
        "Scope": ScopeMacro.self,
        "Store": StoreMacro.self,
    ]

    func testInject() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                @Inject var userService: UserService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var userService: UserService {
                    get {
                        return self._dependencies.userService
                    }
                }

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
                var userService: UserService {
                    get
                }
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testProvide() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                @Provide let date: Date = Date()

                @Provide
                @Store(BarServiceImplementation.self)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                let date: Date = Date()
                var barService: BarService {
                    get {
                        return self._barServiceStore.value
                    }
                }

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private lazy var _barServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return BarServiceImplementation(dependencies: self._childDependenciesStore.value)
                    }
                )

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            fileprivate class FooScopeChildDependencies: BarServiceImplementation.UnownedDependencies {
                private let _parent: FooScope
                fileprivate var date: Date {
                    return self._parent.date
                }
                fileprivate var barService: BarService {
                    return self._parent.barService
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testArgument() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                @Argument var user: User
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                var user: User {
                    get {
                        return self._arguments.user
                    }
                }

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = FooScopeArguments

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testFactory() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                @Provide
                @Factory(FooViewController.self)
                public var rootFactory: Factory<FooViewControllerArguments, UIViewController>

                @Provide
                @Factory(BarScope.self, factory: \\.rootFactory)
                public var barViewControllerFactory: Factory<BarViewControllerArguments, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope {
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

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: WeakBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            fileprivate class FooScopeChildDependencies: FooViewController.Dependencies, BarScope.Dependencies {
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

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testStore() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                @Store(FooServiceImplementation.self, init: .eager)
                var fooService: FooService

                @Provide
                @Store(BarServiceImplementation.self, storage: .weak)
                var barService: BarService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
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

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

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
                        return FooScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                    _ = self.fooService
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            fileprivate class FooScopeChildDependencies: FooServiceImplementation.UnownedDependencies, BarServiceImplementation.Dependencies {
                private let _parent: FooScope
                fileprivate var barService: BarService {
                    return self._parent.barService
                }
                fileprivate init(parent: FooScope) {
                    self._parent = parent
                }
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testStrongChildDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope(childDependencies: .strong)
            public final class RootScope {
                @Store(FooServiceImplementation.self)
                var fooService: FooService
            }
            """,
            expandedSource:
            """
            public final class RootScope {
                var fooService: FooService {
                    get {
                        return self._fooServiceStore.value
                    }
                }

                public typealias Dependencies = RootScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private lazy var _fooServiceStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return FooServiceImplementation(dependencies: self._childDependenciesStore.value)
                    }
                )

                private lazy var _childDependenciesStore = StoreImplementation(
                    backingStore: StrongBackingStoreImplementation(),
                    function: { [unowned self] in
                        return RootScopeChildDependencies(parent: self)
                    }
                )

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol RootScopeDependencies: AnyObject {
            }

            fileprivate class RootScopeChildDependencies: FooServiceImplementation.UnownedDependencies {
                private let _parent: RootScope
                fileprivate init(parent: RootScope) {
                    self._parent = parent
                }
            }

            extension RootScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testHandWrittenInitializer() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self.arguments = arguments
                    self.dependencies = dependencies
                    print("hand written initializer")
                }
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self.arguments = arguments
                    self.dependencies = dependencies
                    print("hand written initializer")
                }

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private let _arguments: Arguments
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }

    func testHandWrittenArgumentsTypeAlias() throws {
        assertMacroExpansion(
            """
            public struct FooSpecialArguments {
                public init() {}
            }

            @Injectable
            @Scope
            public final class FooScope {
                public typealias Arguments = FooSpecialArguments
            }
            """,
            expandedSource:
            """
            public struct FooSpecialArguments {
                public init() {}
            }
            public final class FooScope {
                public typealias Arguments = FooSpecialArguments

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }
}
