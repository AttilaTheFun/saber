import SaberPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ScopeMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Argument": ArgumentMacro.self,
        "Injectable": InjectableMacro.self,
        "Inject": InjectMacro.self,
        "Scope": ScopeMacro.self,
    ]

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

                private weak var _fulfilledDependencies: FooScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: FooScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = FooScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public final class FooScopeFulfilledDependencies {
                private let _parent: FooScope
                fileprivate var user: User {
                    return self._parent.user
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

                private weak var _fulfilledDependencies: FooScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: FooScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = FooScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

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

            public final class FooScopeFulfilledDependencies {
                private let _parent: FooScope
                fileprivate var userService: UserService {
                    return self._parent.userService
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

    func testFulfill() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope
            public final class FooScope {
                let date: Date = Date()

                @Fulfill(BarServiceImplementationUnownedDependencies.self)
                lazy var barService: any BarService = BarServiceImplementation(dependencies: self.fulfilledDependencies)

                @Fulfill(FooViewControllerDependencies.self)
                lazy var fooViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] _ in
                    FooViewController(dependencies: self.fulfilledDependencies)
                }
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                let date: Date = Date()

                @Fulfill(BarServiceImplementationUnownedDependencies.self)
                lazy var barService: any BarService = BarServiceImplementation(dependencies: self.fulfilledDependencies)

                @Fulfill(FooViewControllerDependencies.self)
                lazy var fooViewControllerFactory: Factory<Void, UIViewController> = Factory { [unowned self] _ in
                    FooViewController(dependencies: self.fulfilledDependencies)
                }

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private weak var _fulfilledDependencies: FooScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: FooScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = FooScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public final class FooScopeFulfilledDependencies: BarServiceImplementationUnownedDependencies, FooViewControllerDependencies {
                private let _parent: FooScope
                fileprivate var date: Date {
                    return self._parent.date
                }
                fileprivate var barService: any BarService {
                    return self._parent.barService
                }
                fileprivate var fooViewControllerFactory: Factory<Void, UIViewController> {
                    return self._parent.fooViewControllerFactory
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

    func testStrongFulfilledDependencies() throws {
        assertMacroExpansion(
            """
            @Injectable
            @Scope(fulfilledDependencies: .strong)
            public final class RootScope {
                let date: Date = Date()
            }
            """,
            expandedSource:
            """
            public final class RootScope {
                let date: Date = Date()

                public typealias Dependencies = RootScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private weak var _fulfilledDependencies: RootScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: RootScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = RootScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol RootScopeDependencies: AnyObject {
            }

            public final class RootScopeFulfilledDependencies {
                private let _parent: RootScope
                fileprivate var date: Date {
                    return self._parent.date
                }
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

                private weak var _fulfilledDependencies: FooScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: FooScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = FooScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

                private let _arguments: Arguments
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public final class FooScopeFulfilledDependencies {
                private let _parent: FooScope
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

                private weak var _fulfilledDependencies: FooScopeFulfilledDependencies?

                private let _fulfilledDependenciesLock = Lock()

                fileprivate var fulfilledDependencies: FooScopeFulfilledDependencies {
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    self._fulfilledDependenciesLock.lock()
                    defer {
                        self._fulfilledDependenciesLock.unlock()
                    }
                    if let fulfilledDependencies = self._fulfilledDependencies {
                        return fulfilledDependencies
                    }
                    let fulfilledDependencies = FooScopeFulfilledDependencies(parent: self)
                    self._fulfilledDependencies = fulfilledDependencies
                    return fulfilledDependencies
                }

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public final class FooScopeFulfilledDependencies {
                private let _parent: FooScope
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
}
