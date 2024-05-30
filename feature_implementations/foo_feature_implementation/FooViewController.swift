import BarFeatureInterface
import DependencyFoundation
import FooFeatureInterface
import FooServiceInterface

public typealias FooDependencies
    = DependencyProvider
    & FooServiceProvider
    & BarRouteHandlerProvider

@MainActor
public final class FooRouteHandler: DependencyContainer<FooDependencies>, RouteHandler {
    public func destination(of route: FooRoute) -> UIViewController {
        return FooViewController(dependencies: self.dependencies)
    }
}

@MainActor
final class FooViewController: UIViewController {
    private let fooService: FooService
    private let barRouteHandler: any RouteHandler<BarRoute>

    init(dependencies: FooDependencies) {
        self.fooService = dependencies.fooService
        self.barRouteHandler = dependencies.barRouteHandler
        super.init()
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
        let barRoute = BarRoute(barID: barID)
        let barViewController = self.barRouteHandler.destination(of: barRoute)
        self.present(barViewController, animated: true)
    }
}