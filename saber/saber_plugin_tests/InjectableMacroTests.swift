import SaberPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Argument": ArgumentMacro.self,
        "Injectable": InjectableMacro.self,
        "Inject": InjectMacro.self,
    ]

    func testArgument() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooObject {
                @Argument var user: User
            }
            """,
            expandedSource:
            """
            public final class FooObject {
                var user: User {
                    get {
                        return self._arguments.user
                    }
                }

                public typealias Arguments = FooObjectArguments

                public typealias Dependencies = FooObjectDependencies

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooObjectDependencies: AnyObject {
            }

            extension FooObject: Injectable {
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
            }
            """,
            expandedSource:
            """
            public final class FooObject {
                var fooService: FooService {
                    get {
                        return self._dependencies.fooService
                    }
                }

                public typealias Arguments = Void

                public typealias Dependencies = FooObjectDependencies

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooObjectDependencies: AnyObject {
                var fooService: FooService {
                    get
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

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
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

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
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

                public typealias Dependencies = FooServiceImplementationUnownedDependencies

                private unowned let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
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

    func testHandWrittenInitializer() throws {
        assertMacroExpansion(
            """
            @Injectable
            public final class FooObject {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self.arguments = arguments
                    self.dependencies = dependencies
                    print("hand written initializer")
                }
            }
            """,
            expandedSource:
            """
            public final class FooObject {
                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self.arguments = arguments
                    self.dependencies = dependencies
                    print("hand written initializer")
                }

                public typealias Arguments = Void

                public typealias Dependencies = FooObjectDependencies

                private let _dependencies: any Dependencies

                private let _arguments: Arguments
            }

            public protocol FooObjectDependencies: AnyObject {
            }

            extension FooObject: Injectable {
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
            public final class FooObject {
                public typealias Arguments = FooSpecialArguments
            }
            """,
            expandedSource:
            """
            public struct FooSpecialArguments {
                public init() {}
            }
            public final class FooObject {
                public typealias Arguments = FooSpecialArguments

                public typealias Dependencies = FooObjectDependencies

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            public protocol FooObjectDependencies: AnyObject {
            }

            extension FooObject: Injectable {
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
            public final class FooObject {
                public typealias Dependencies = FooSpecialDependencies
            }
            """,
            expandedSource:
            """
            public protocol FooSpecialDependencies {
            }
            public final class FooObject {
                public typealias Dependencies = FooSpecialDependencies

                public typealias Arguments = Void

                private let _dependencies: any Dependencies

                private let _arguments: Arguments

                public init(arguments: Arguments, dependencies: any Dependencies) {
                    self._arguments = arguments
                    self._dependencies = dependencies
                }
            }

            extension FooObject: Injectable {
            }
            """,
            macros: self.macros
        )
    }
}
