
public protocol Injectable<Arguments, Dependencies> {
    associatedtype Arguments
    associatedtype Dependencies
    
    init(arguments: Arguments, dependencies: Dependencies)
}

extension Injectable where Arguments == Void {
    init(dependencies: Dependencies) {
        self.init(arguments: (), dependencies: dependencies)
    }
}
