import UserSessionServiceInterface

public struct LoadingFeature {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
