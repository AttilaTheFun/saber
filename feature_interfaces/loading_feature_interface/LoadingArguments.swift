import UserSessionServiceInterface

public struct LoadingArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
