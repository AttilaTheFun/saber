import Foundation

// @Provider
public struct RootFeatureArguments {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}

// TODO: Generate with @Provider macro.
public protocol RootFeatureArgumentsProvider {
    var rootFeatureArguments: RootFeatureArguments { get }
}
