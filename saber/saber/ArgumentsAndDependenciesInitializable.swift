import Foundation

public protocol ArgumentsAndDependenciesInitializable {
    associatedtype Arguments
    associatedtype Dependencies
    init(arguments: Arguments, dependencies: Dependencies)
}

extension ArgumentsAndDependenciesInitializable where Arguments == Void {
    public init(dependencies: Dependencies) {
        self.init(arguments: (), dependencies: dependencies)
    }
}
