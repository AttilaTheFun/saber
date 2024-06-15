import UIKit

public protocol WindowService {
    func register(rootViewControllerFactory: @escaping () -> UIViewController)
    func opened(window: UIWindow)
    func closed(window: UIWindow)
}
