
extension String {
    func lowercasedFirstCharacter() -> String {
        guard let first else { return self }
        return first.lowercased() + self.dropFirst()
    }
}
