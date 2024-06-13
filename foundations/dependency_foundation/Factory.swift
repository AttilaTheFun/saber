
public protocol Factory<Arguments, Building> {
    associatedtype Arguments
    associatedtype Building

    func build(arguments: Arguments) -> Building
}
//
//public final class DependenciesFactory<Dependencies, Arguments, Building>: Factory {
//    public init(closure: )
//
//    public func build(arguments: Arguments) -> Building {
//
//    }
//}
