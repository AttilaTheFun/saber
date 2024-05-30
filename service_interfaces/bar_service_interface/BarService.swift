
public protocol BarService {
    func bar() async throws
}

public protocol BarServiceProvider {
    var barService: BarService { get }
}