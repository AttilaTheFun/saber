import UserSessionServiceInterface

public struct LoadingViewControllerArguments {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
