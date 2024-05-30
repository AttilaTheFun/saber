
@MainActor
open class DependencyContainer<Dependencies> {
    public let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}