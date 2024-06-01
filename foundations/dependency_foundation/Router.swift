
public protocol Router<Arguments> {
    associatedtype Arguments

    func route(arguments: Arguments)
}
