import DependencyFoundation
import LoggedOutScopeInterface
import UserSessionServiceInterface
import UserSessionServiceImplementation
import SwiftFoundation

// TODO: Generate with @Buildable macro.
public final class LoggedOutScopeImplementationBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedOutScopeArguments) -> AnyObject {
        return LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeImplementationDependencies
    = DependencyProvider
    & UserSessionStorageServiceProvider
    & UserSessionServiceProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Instantiate(UserSessionStorageServiceImplementation.self)
    // let userStorageService: UserSessionStorageService

    // @Arguments
    let arguments: LoggedOutScopeArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedOutScopeImplementation: UserSessionStorageServiceProvider {
    var userSessionStorageService: any UserSessionStorageService {
        return self.dependencies.userSessionStorageService
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return UserSessionServiceImplementation(dependencies: self)
    }
}
