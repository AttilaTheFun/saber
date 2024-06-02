import BarFeatureInterface
import DependencyFoundation
import FooFeatureInterface
import FooServiceInterface
import UIKit

// TODO: Generate with @Builder macro.
public final class FooFeatureBuilder: DependencyContainer<FooFeatureDependencies>, Builder {
    public func build(arguments: FooFeatureArguments) -> UIViewController {
        return FooFeatureViewController(dependencies: self.dependencies, arguments: arguments)
    }
}

// TODO: Generate with @Injectable macro.
public typealias FooFeatureDependencies
    = DependencyProvider
    & FooServiceProvider
    & BarFeatureBuilderProvider

// @Builder(building: UIViewController.swift)
// @Injectable
final class FooFeatureViewController: UIViewController {

    // @Inject
    private let fooService: FooService

    // @Inject
    private let barFeatureBuilder: any Builder<BarFeatureArguments, UIViewController>

    // @Arguments
    private let arguments: FooFeatureArguments

    // TODO: Generate with @Injectable macro.
    init(dependencies: FooFeatureDependencies, arguments: FooFeatureArguments) {
        self.fooService = dependencies.fooService
        self.barFeatureBuilder = dependencies.barFeatureBuilder
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
                let barID = try await self.fooService.foo()
                await self.navigate(to: barID)
            } catch {
                print(error)
            }
        }
    }

    private func navigate(to barID: String) async {
        let barFeatureArguments = BarFeatureArguments(barID: barID, other: 0)
        let barViewController = self.barFeatureBuilder.build(arguments: barFeatureArguments)
        self.present(barViewController, animated: true)
    }
}
