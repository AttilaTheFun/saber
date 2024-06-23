import Foundation

public protocol DependenciesInitializable {
    associatedtype Dependencies
    init(dependencies: Dependencies)
}
