import DependencyFoundation
import UserSessionServiceInterface
import UserSessionServiceImplementation
import UserServiceInterface
import UserServiceImplementation
import InitialScopeInterface
import InitialScopeImplementation
import LoggedInScopeInterface
import LoggedInScopeImplementation
import LoggedOutScopeInterface
import LoggedOutScopeImplementation
import LoadingScopeInterface
import LoadingScopeImplementation
import RootScopeInterface

// TODO: Generate with @Injectable macro.
public typealias RootScopeImplementationDependencies
    = DependencyProvider

// @Injectable
public final class RootScopeImplementation: Scope<RootScopeImplementationDependencies> {

    // @Instantiate(UserSessionStorageServiceImplementation.self)
    // let userSessionStorageService: UserSessionStorageService

    // @Instantiate(UserSessionServiceImplementation.self)
    // let userSessionService: UserSessionService

    // @Instantiate(UserStorageServiceImplementation.self)
    // let userStorageService: UserStorageService

    // @Instantiate(InitialScopeImplementationBuilder.swift)
    // let initialScopeBuilder: Builder<InitialScopeArguments, AnyObject>

    // @Instantiate(LoggedOutScopeImplementationBuilder.swift)
    // let loggedOutScopeBuilder: Builder<LoggedOutScopeArguments, AnyObject>

    // @Instantiate(LoadingScopeImplementationBuilder.swift)
    // let loadingScopeBuilder: Builder<LoadingScopeArguments, AnyObject>

    // @Instantiate(LoggedInScopeImplementationBuilder.swift)
    // let loggedInScopeBuilder: Builder<LoggedInScopeArguments, AnyObject>

    // @Arguments
    public let arguments: RootScopeArguments

    // TODO: Generate with @Injectable macro.
    public init(dependencies: RootScopeImplementationDependencies, arguments: RootScopeArguments) {
        self.arguments = arguments
        super.init(dependencies: dependencies)
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: UserSessionStorageServiceProvider {
    public var userSessionStorageService: any UserSessionStorageService {
        return self.strong { [unowned self] in
            UserSessionStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: UserSessionServiceProvider {
    public var userSessionService: any UserSessionService {
        return self.strong { [unowned self] in
            UserSessionServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: UserStorageServiceProvider {
    public var userStorageService: any UserStorageService {
        return self.strong { [unowned self] in
            UserStorageServiceImplementation(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: InitialScopeBuilderProvider {
    public var initialScopeBuilder: any Builder<InitialScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            InitialScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: LoggedOutScopeBuilderProvider {
    public var loggedOutScopeBuilder: any Builder<LoggedOutScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoggedOutScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: LoadingScopeBuilderProvider {
    public var loadingScopeBuilder: any Builder<LoadingScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoadingScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Instantiate macro.
extension RootScopeImplementation: LoggedInScopeBuilderProvider {
    public var loggedInScopeBuilder: any Builder<LoggedInScopeArguments, AnyObject> {
        return self.new { [unowned self] in
            LoggedInScopeImplementationBuilder(dependencies: self)
        }
    }
}

// TODO: Generate from @Arguments macro.
extension RootScopeImplementation: RootScopeArgumentsProvider {}
