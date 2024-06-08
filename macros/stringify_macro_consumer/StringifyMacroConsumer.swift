import StringifyMacro

@main
struct Main {
  static func main() {
    print(#stringify(1 + 3))
  }
}
