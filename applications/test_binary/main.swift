import SwiftFoundation

print("1")
let lazyValue = Lazy<Int> {
    print("initialized lazy value")
    return Int.random(in: Int.min...Int.max)
}
print("2")
lazyValue.value
print("3")

