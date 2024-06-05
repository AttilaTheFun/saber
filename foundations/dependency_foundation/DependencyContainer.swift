
@MainActor
open class DependencyContainer<Dependencies>: DependencyProvider {
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
