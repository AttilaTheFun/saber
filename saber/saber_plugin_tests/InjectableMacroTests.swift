import SaberPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectableMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Injectable": InjectableMacro.self,
        "Inject": InjectMacro.self,
    ]

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
                        return self.dependencies.fooService
                    }
                }

                public typealias Dependencies = FooObjectDependencies

                public let dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
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

                public typealias Dependencies = FooViewControllerDependencies

                public let dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
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

                public typealias Dependencies = FooViewDependencies

                public let dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
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

                public typealias Dependencies = FooServiceImplementationUnownedDependencies

                public unowned let dependencies: any UnownedDependencies

                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
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
            public final class Foo {
                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
                    print("hand written initializer")
                }
            }
            """,
            expandedSource:
            """
            public final class Foo {
                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
                    print("hand written initializer")
                }

                public typealias Dependencies = FooDependencies

                public let dependencies: any Dependencies
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

                public let dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self.dependencies = dependencies
                }
            }

            extension FooObject: Injectable {
            }
            """,
            macros: self.macros
        )
    }
}
