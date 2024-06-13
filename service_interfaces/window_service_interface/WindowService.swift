import DependencyMacros
import UIKit

public protocol WindowService {
    func register(rootViewControllerBuilder: @escaping () -> UIViewController)
    func opened(window: UIWindow)
    func closed(window: UIWindow)
}
