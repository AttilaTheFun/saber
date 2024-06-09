import DependencyFoundation
import UIKit
import UserSessionServiceInterface

@BuilderProvider(UIViewController.self)
@Provider
public struct LoadingFeature {
    public let userSession: UserSession

    public init(userSession: UserSession) {
        self.userSession = userSession
    }
}
