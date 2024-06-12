import SwiftSyntax

public enum TypeDescriptionError: Error {
    case unsupportedType(TypeSyntax)
}

public struct TypeDescription: Hashable, Sendable {
    public let name: String
    
    init(type: TypeSyntax) throws {
        if let identifierTypeSyntax = type.as(IdentifierTypeSyntax.self) {
            self.name = identifierTypeSyntax.name.text
        } else if let someOrAnyTypeSyntax = type.as(SomeOrAnyTypeSyntax.self) {
            var name = "\(someOrAnyTypeSyntax.someOrAnySpecifier.text)"
            if let identifierTypeSyntax = someOrAnyTypeSyntax.constraint.as(IdentifierTypeSyntax.self) {
                name += " \(identifierTypeSyntax.name.text)"
                if let genericArgumentClause = identifierTypeSyntax.genericArgumentClause {
                    let genericTypeNames = try genericArgumentClause.arguments
                        .map { try TypeDescription(type: $0.argument) }
                        .map { $0.name }
                    name += "<\(genericTypeNames.joined(separator: ", "))>"
                }
            } else {
                // TODO: Do we want to handle any other syntax?
                throw TypeDescriptionError.unsupportedType(type)
            }

            self.name = name
        } else {
            // TODO: Do we want to handle any other type annotations?
            throw TypeDescriptionError.unsupportedType(type)
        }
    }
}
