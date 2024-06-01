import BarFeatureInterface
import DependencyFoundation
import BarFeatureInterface
import BarServiceInterface
import UIKit

// TODO: Generate with @Builder macro.
public final class BarBuilder: DependencyContainer<BarFeatureDependencies>, Builder {
    public func build(arguments: BarFeatureArguments) -> UIViewController {
        return BarFeatureViewController(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias BarFeatureDependencies
    = DependencyProvider
    & BarServiceProvider

// @Builder(building: UIViewController.self)
// @Injectable
final class BarFeatureViewController: UIViewController {

    // @Inject
    private let barService: BarService

    // @Arguments
    private let arguments: BarFeatureArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: BarFeatureDependencies, arguments: BarFeatureArguments) {
        self.barService = dependencies.barService
        self.arguments = arguments
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: Generate with @Injectable macro.
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func buttonTapped() {
        Task.detached {
            do {
                let barID = try await self.barService.bar()
                print(barID)
            } catch {
                print(error)
            }
        }
    }
}