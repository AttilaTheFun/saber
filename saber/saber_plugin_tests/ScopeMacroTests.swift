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

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public protocol FooScopeFulfilledDependencies: AnyObject {
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

            public protocol FooScopeFulfilledDependencies: AnyObject {
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
                public let date: Date = Date()

                @Store(InboxServiceImplementation.self)
                public var inboxService: any InboxService

                @Factory(InboxViewController.self)
                public var rootFactory: Factory<Void, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                public let date: Date = Date()

                @Store(InboxServiceImplementation.self)
                public var inboxService: any InboxService

                @Factory(InboxViewController.self)
                public var rootFactory: Factory<Void, UIViewController>

                public typealias Dependencies = FooScopeDependencies

                private let _dependencies: any Dependencies

                public typealias Arguments = Void

                private lazy var inboxServiceStore = Store { [unowned self] in
                    InboxServiceImplementation(dependencies: self)
                }

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooScopeDependencies: AnyObject {
            }

            public protocol FooScopeFulfilledDependencies: AnyObject, InboxViewControllerDependencies, InboxServiceImplementationUnownedDependencies {
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
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

            public protocol FooScopeFulfilledDependencies: AnyObject {
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

            public protocol FooScopeFulfilledDependencies: AnyObject {
            }

            extension FooScope: ArgumentsAndDependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }
}
