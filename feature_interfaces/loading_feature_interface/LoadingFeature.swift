import DependencyFoundation
import DependencyMacros
import UIKit
import UserSessionServiceInterface

@BuilderProvider
public struct LoadingFeature {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
