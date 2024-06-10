import DependencyFoundation
import UIKit
import UserSessionServiceInterface

@Provider
@BuilderProvider
public struct LoadingFeature {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
