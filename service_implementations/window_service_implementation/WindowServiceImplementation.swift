import DependencyFoundation
import UIKit
import WindowServiceInterface

// TODO: Generate with @Injectable macro.
public typealias WindowServiceImplementationDependencies
    = DependencyProvider

// @Injectable
public final class WindowServiceImplementation: WindowService {
    public private(set) var openWindows: [UIWindow] = []

    // TODO: Generate with @Injectable macro.
    public init(dependencies: WindowServiceImplementationDependencies) {}

    public func opened(window: UIWindow) {
        self.openWindows.append(window)
    }

    public func closed(window: UIWindow) {
        self.openWindows = self.openWindows.filter { $0 !== window }
    }
}
