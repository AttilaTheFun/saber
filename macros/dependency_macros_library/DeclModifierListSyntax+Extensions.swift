import SwiftSyntax

private let accessLevels = Set(["open", "public", "internal", "fileprivate", "private"])

extension DeclModifierListSyntax {
    public var accessLevel: String {
        return self.first { modifier in
            accessLevels.contains(modifier.name.text)
        }?.name.text ?? "internal"
    }

    public var isStatic: Bool {
        return self.contains { modifier in
            modifier.name.text == "static"
        }
    }
}
