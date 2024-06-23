import Foundation
import SaberTypes

public protocol DependenciesInitializable {
    associatedtype Dependencies
    init(dependencies: Dependencies)
}
