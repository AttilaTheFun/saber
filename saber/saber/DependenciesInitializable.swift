import Foundation
import SaberTypes

public protocol DependenciesInitializable {
    associatedtype Dependencies
    init(dependencies: Dependencies)
}

extension DependenciesInitializable {
    public init<Arguments>(arguments: Arguments, dependencies: Dependencies) {
        self.init(dependencies: dependencies)
    }
}
