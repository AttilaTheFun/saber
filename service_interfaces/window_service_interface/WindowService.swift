import DependencyFoundation
import UIKit

// @ServiceProvider
public protocol WindowService {
    func register(rootViewControllerBuilder: @escaping () -> UIViewController)
    func opened(window: UIWindow)
    func closed(window: UIWindow)
}

// TODO: Generate with @ServiceProvider macro.
public protocol WindowServiceProvider {
    var windowService: WindowService { get }
}
