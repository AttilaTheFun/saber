import Foundation

public protocol ArgumentsAndDependenciesInitializable {
    associatedtype Arguments
    associatedtype Dependencies
    init(arguments: Arguments, dependencies: Dependencies)
}
