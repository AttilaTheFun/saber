import Foundation

public struct RootArguments {
    public init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    public let endpointURL: URL
}
