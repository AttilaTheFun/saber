import Foundation

// @Provider
public struct RootScopeArguments {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}

// TODO: Generate with @Provider macro.
public protocol RootScopeArgumentsProvider {
    var rootScopeArguments: RootScopeArguments { get }
}
