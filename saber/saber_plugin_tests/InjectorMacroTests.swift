import SaberPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class InjectorMacroTests: XCTestCase {
    private let macros: [String : any Macro.Type] = [
        "Factory": FactoryMacro.self,
        "Injector": InjectorMacro.self,
        "Store": StoreMacro.self,
    ]

    func testFactory() throws {
        assertMacroExpansion(
            """
            @Injector
            public final class FooScope {
                public var locationService: LocationService {
                    CLLocationManager.shared
                }

                @Factory(InboxViewController.self)
                public var rootFactory: Factory<Void, UIViewController>
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                public var locationService: LocationService {
                    CLLocationManager.shared
                }
                public var rootFactory: Factory<Void, UIViewController> {
                    get {
                        Factory { arguments in
                            InboxViewController(arguments: arguments, dependencies: self)
                        }
                    }
                }
            }

            public protocol FooScopeFulfilledDependencies: AnyObject, InboxViewControllerDependencies {
            }
            """,
            macros: self.macros
        )
    }

    func testStore() throws {
        assertMacroExpansion(
            """
            @Injector
            public final class FooScope {
                public let date: Date = Date()

                @Store(InboxServiceImplementation.self)
                public var inboxService: any InboxService
            }
            """,
            expandedSource:
            """
            public final class FooScope {
                public let date: Date = Date()
                public var inboxService: any InboxService {
                    get {
                        return self.inboxServiceStore.value
                    }
                }

                private lazy var inboxServiceStore = Store { [unowned self] in
                    InboxServiceImplementation(dependencies: self)
                }
            }

            public protocol FooScopeFulfilledDependencies: AnyObject, InboxServiceImplementationUnownedDependencies {
            }
            """,
            macros: self.macros
        )
    }
}
