import DependencyMacros
import UIKit
import WindowServiceInterface

@Injectable
public final class WindowServiceImplementation: WindowService {
    private var rootViewControllerBuilder: () -> UIViewController = {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            return viewController
        } else {
            return UIViewController()
        }
    }
    private var openWindows: [UIWindow] = []

    public func register(rootViewControllerBuilder: @escaping () -> UIViewController) {
        self.rootViewControllerBuilder = rootViewControllerBuilder
        for window in self.openWindows {
            self.updateRootViewController(window: window)
        }
    }

    public func opened(window: UIWindow) {
        self.openWindows.append(window)
        self.updateRootViewController(window: window)
    }

    public func closed(window: UIWindow) {
        self.openWindows = self.openWindows.filter { $0 !== window }
    }

    private func updateRootViewController(window: UIWindow) {
        let newRootViewController = self.rootViewControllerBuilder()
        let hasExistingRootViewController = window.rootViewController != nil
        window.rootViewController = newRootViewController
        if hasExistingRootViewController {
            UIView.transition(
                with: window,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        } else {
            window.makeKeyAndVisible()
        }
    }
}
