import Foundation

// @ScopeArguments
public struct RootScopeArguments {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}

// TODO: Generate with @ScopeArguments macro.
public protocol RootScopeArgumentsProvider {
    var arguments: RootScopeArguments { get }
}
