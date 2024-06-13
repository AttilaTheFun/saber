import SwiftSyntax

public enum VoidSpelling: String, Hashable, Sendable {

    /// The `()` spelling.
    case tuple = "()"

    /// The `Void` spelling.
    case identifier = "Void"
}

public enum TypeDescriptionError: Error {
    case unsupportedType(TypeSyntax)
    case unsupportedExpression(ExprSyntax)
}

public enum TypeDescription: Hashable, Sendable {

    /// The Void or () type.
    case void(VoidSpelling)

    /// A root type with possible generics. e.g. Int, or Array<Int>
    indirect case simple(name: String, generics: [TypeDescription])

    /// A nested type with possible generics. e.g. Array.Element or Swift.Array<Element>
    indirect case nested(name: String, parentType: TypeDescription, generics: [TypeDescription])

    /// An opaque type that conforms to a protocol. e.g. some Equatable
    indirect case some(TypeDescription)

    /// An opaque type that conforms to a protocol. e.g. any Equatable
    indirect case any(TypeDescription)

    /// A meta type. e.g. `Int.Type` or `Equatable.Protocol`
    indirect case metatype(description: TypeDescription, isType: Bool)

    /// The type could not be determined.
    case unknown(description: String)
}

extension TypeDescription {

    /// A canonical representation of this type that can be used in source code.
    public var asSource: String {
        switch self {
        case let .void(spelling):
            return spelling.rawValue
        case let .simple(name, generics):
            if generics.isEmpty {
                return name
            } else {
                return "\(name)<\(generics.map(\.asSource).joined(separator: ", "))>"
            }
        case let .nested(name, parentType, generics):
            if generics.isEmpty {
                return "\(parentType.asSource).\(name)"
            } else {
                return "\(parentType.asSource).\(name)<\(generics.map(\.asSource).joined(separator: ", "))>"
            }
        case let .some(type):
            return "some \(type.asSource)"
        case let .any(type):
            return "any \(type.asSource)"
        case let .metatype(type, isType):
            return "\(type.asSource).\(isType ? "Type" : "Protocol")"
        case let .unknown(description):
            fatalError("Unknown Type: " + description)
        }
    }
}

extension TypeSyntax {
    public var typeDescription: TypeDescription {

        // Handle IdentifierTypeSyntax:
        if let typeIdentifier = IdentifierTypeSyntax(self) {
            let genericArguments: [TypeDescription]
            if let genericArgumentClause = typeIdentifier.genericArgumentClause {
                let genericTypeVisitor = GenericArgumentVisitor(viewMode: .sourceAccurate)
                genericTypeVisitor.walk(genericArgumentClause)
                genericArguments = genericTypeVisitor.genericArguments
            } else {
                genericArguments = []
            }

            if genericArguments.isEmpty, typeIdentifier.name.text == "Void" {
                return .void(.identifier)
            }

            return .simple(
                name: typeIdentifier.name.text,
                generics: genericArguments
            )
        } 

        // Handle SomeOrAnyTypeSyntax:
        if let typeIdentifier = SomeOrAnyTypeSyntax(self) {
            if typeIdentifier.someOrAnySpecifier.text == "some" {
                return .some(typeIdentifier.constraint.typeDescription)
            }

            return .any(typeIdentifier.constraint.typeDescription)
        }

        // Handle MetatypeTypeSyntax:
        if let typeIdentifier = MetatypeTypeSyntax(self) {
            return .metatype(
                description: typeIdentifier.baseType.typeDescription,
                isType: typeIdentifier.metatypeSpecifier.text == "Type"
            )
        }

        return .unknown(description: self.trimmedDescription)
    }
}

extension ExprSyntax {
    public var typeDescription: TypeDescription {
        if let typeExpr = TypeExprSyntax(self) {
            return typeExpr.type.typeDescription

        } else if let declReferenceExpr = DeclReferenceExprSyntax(self) {
            return TypeSyntax(
                IdentifierTypeSyntax(
                    name: declReferenceExpr.baseName,
                    genericArgumentClause: nil
                )
            ).typeDescription
        } else if let memberAccessExpr = MemberAccessExprSyntax(self) {
            if memberAccessExpr.declName.baseName.text == "self" {
                if let base = memberAccessExpr.base {
                    return base.typeDescription
                } else {
                    return .unknown(description: memberAccessExpr.trimmedDescription)
                }
            } else {
                if let base = memberAccessExpr.base {
                    let declName = memberAccessExpr.declName.baseName.text
                    if declName == "Type" {
                        return .metatype(description: base.typeDescription, isType: true)
                    } else if declName == "Protocol" {
                        return .metatype(description: base.typeDescription, isType: false)
                    } else {
                        return .nested(
                            name: declName,
                            parentType: base.typeDescription,
                            generics: []
                        )
                    }
                } else {
                    return .unknown(description: memberAccessExpr.trimmedDescription)
                }
            }
        }

        return .unknown(description: self.trimmedDescription)
    }
}

private final class GenericArgumentVisitor: SyntaxVisitor {
    private(set) var genericArguments = [TypeDescription]()

    override func visit(_ node: GenericArgumentSyntax) -> SyntaxVisitorContinueKind {
        self.genericArguments.append(node.argument.typeDescription)
        return .skipChildren
    }
}
