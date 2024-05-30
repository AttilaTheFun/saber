
public protocol BarService {
    func bar() async throws
}

public protocol BarServiceProvider {
    var barService: any BarService { get }
}