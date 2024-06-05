import DependencyFoundation
import UIKit

// @Provider
public protocol WindowService {
    func register(rootViewControllerBuilder: @escaping () -> UIViewController)
    func opened(window: UIWindow)
    func closed(window: UIWindow)
}

// TODO: Generate with @Provider macro.
public protocol WindowServiceProvider {
    var windowService: WindowService { get }
}
