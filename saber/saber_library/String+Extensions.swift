
extension String {
    public func lowercasedFirstCharacter() -> String {
        guard let first else { return self }
        return first.lowercased() + self.dropFirst()
    }

    public func uppercasedFirstCharacter() -> String {
        guard let first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}
