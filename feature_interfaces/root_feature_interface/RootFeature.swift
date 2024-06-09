import DependencyFoundation
import Foundation

@Provider
public struct RootFeature {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}
