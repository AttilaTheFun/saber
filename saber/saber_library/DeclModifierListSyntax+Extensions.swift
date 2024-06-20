import SwiftSyntax

extension DeclModifierListSyntax {
    public var accessLevel: AccessLevel {
        return self.compactMap { modifier in
            return AccessLevel(rawValue: modifier.name.text)
        }.first ?? .accessLevelInternal
    }

    public var isStatic: Bool {
        return self.contains { modifier in
            modifier.name.text == "static"
        }
    }
}
