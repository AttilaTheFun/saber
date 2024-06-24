import Foundation

public protocol Injectable {
    associatedtype Arguments
    associatedtype Dependencies
    init(arguments: Arguments, dependencies: Dependencies)
}

extension Injectable where Arguments == Void {
    public init(dependencies: Dependencies) {
        self.init(arguments: (), dependencies: dependencies)
    }
}
