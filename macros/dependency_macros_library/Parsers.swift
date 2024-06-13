import SwiftSyntax

public struct NominalTypeSyntax {
    public let modifiers: DeclModifierListSyntax
    public let name: TokenSyntax
    public let inheritanceClause: InheritanceClauseSyntax?
}

public enum ParserError: Error {
    case invalidExprSyntax(ExprSyntax)
    case invalidDeclSyntax(any SyntaxProtocol)
}

public enum Parsers {
    public static func parseClassNominalTypeSyntaxOptional(declaration: some SyntaxProtocol) -> NominalTypeSyntax? {
        if let declaration = declaration.as(ClassDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }

        return nil
    }

    public static func parseConcreteNominalTypeSyntaxOptional(declaration: some SyntaxProtocol) -> NominalTypeSyntax? {
        if let nominalType = self.parseClassNominalTypeSyntaxOptional(declaration: declaration) {
            return nominalType
        }
        if let declaration = declaration.as(ActorDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }
        if let declaration = declaration.as(StructDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }
        if let declaration = declaration.as(EnumDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }

        return nil
    }

    public static func parseNominalTypeSyntax(declaration: some SyntaxProtocol) throws -> NominalTypeSyntax {
        if let nominalType = self.parseConcreteNominalTypeSyntaxOptional(declaration: declaration) {
            return nominalType
        }
        if let declaration = declaration.as(ProtocolDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }

        throw ParserError.invalidDeclSyntax(declaration)
    }
}
