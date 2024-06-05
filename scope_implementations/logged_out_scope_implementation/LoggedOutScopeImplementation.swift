import AuthenticationFeatureInterface
import AuthenticationFeatureImplementation
import DependencyFoundation
import LoggedOutScopeInterface
import LoadingScopeInterface
import SwiftFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UIKit

// TODO: Generate with @Buildable macro.
public final class LoggedOutScopeImplementationBuilder: DependencyContainer<LoggedOutScopeImplementationDependencies>, Builder {
    public func build(arguments: LoggedOutScopeArguments) -> AnyObject {
        return LoggedOutScopeImplementation(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias LoggedOutScopeImplementationDependencies
    = DependencyProvider
    & LoadingScopeBuilderProvider

// @Buildable(building: AnyObject.self)
// @Injectable
final class LoggedOutScopeImplementation: Scope<LoggedOutScopeImplementationDependencies> {

    // @Propagate
    // let loadingScopeBuilder: LoadingScopeBuilder

    // @Propagate
    // let userSessionStorageService: UserSessionStorageService

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Provide(Builder<AuthenticationFeatureArguments, UIViewController>.self)
    // @Instantiate
    // let authenticationFeatureBuilder: AuthenticationFeatureBuilder

    // @Arguments
    let arguments: LoggedOutScopeArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: LoggedOutScopeImplementationDependencies, arguments: LoggedOutScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from the @Propagate macro.
extension LoggedOutScopeImplementation: LoadingScopeBuilderProvider {
    var loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject> {
        return self.dependencies.loadingScopeBuilder
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: UserSessionServiceProvider {
    var userSessionService: any UserSessionService {
        return UserSessionServiceImplementation(dependencies: self)
    }
}

// TODO: Generate from the @Instantiate macro.
extension LoggedOutScopeImplementation: AuthenticationFeatureBuilderProvider {
    var authenticationFeatureBuilder: any Builder<AuthenticationFeatureArguments, UIViewController> {
        return AuthenticationFeatureBuilder(dependencies: self)
    }
}
