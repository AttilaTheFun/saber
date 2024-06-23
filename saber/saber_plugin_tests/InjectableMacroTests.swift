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
                        return self._dependencies.fooService
                    }
                }

                public typealias Dependencies = FooObjectDependencies

                private let _dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooObjectDependencies: AnyObject {
                var fooService: FooService {
                    get
                }
            }

            extension FooObject: DependenciesInitializable {
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

                private let _dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                    super.init(nibName: nil, bundle: nil)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }

            public protocol FooViewControllerDependencies: AnyObject {
            }

            extension FooViewController: DependenciesInitializable {
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

                private let _dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                    super.init(frame: .zero)
                }

                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
            }

            public protocol FooViewDependencies: AnyObject {
            }

            extension FooView: DependenciesInitializable {
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

                private unowned let _dependencies: any UnownedDependencies

                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                }
            }

            public protocol FooServiceImplementationUnownedDependencies: AnyObject {
            }

            extension FooServiceImplementation: DependenciesInitializable {
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
                    self._dependencies = dependencies
                    print("hand written initializer")
                }
            }
            """,
            expandedSource:
            """
            public final class Foo {
                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                    print("hand written initializer")
                }

                public typealias Dependencies = FooDependencies

                private let _dependencies: any Dependencies
            }

            public protocol FooDependencies: AnyObject {
            }

            extension Foo: DependenciesInitializable {
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

                private let _dependencies: any Dependencies

                public init(dependencies: any Dependencies) {
                    self._dependencies = dependencies
                }
            }

            extension FooObject: DependenciesInitializable {
            }
            """,
            macros: self.macros
        )
    }
}
