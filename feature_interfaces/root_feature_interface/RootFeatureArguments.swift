import DependencyFoundation
import Foundation

@Provider
public struct RootFeatureArguments {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}
