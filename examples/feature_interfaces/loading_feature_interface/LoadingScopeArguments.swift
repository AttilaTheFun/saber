import UserSessionServiceInterface

public struct LoadingScopeArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
