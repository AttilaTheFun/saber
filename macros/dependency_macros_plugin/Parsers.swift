import SwiftSyntax

struct NominalTypeSyntax {
    let modifiers: DeclModifierListSyntax
    let name: TokenSyntax
    let inheritanceClause: InheritanceClauseSyntax?
}

public enum ParserError: Error {
    case invalidExprSyntax(ExprSyntax)
    case invalidDeclSyntax(any DeclSyntaxProtocol)
}

enum Parsers {
    static func parseMemberAccessBaseTypeName(expression: ExprSyntax) throws -> TokenSyntax {
        guard let memberAccessExpression = expression.as(MemberAccessExprSyntax.self) else {
            throw ParserError.invalidExprSyntax(expression)
        }
        guard let nestedExpression = memberAccessExpression.base else {
            throw ParserError.invalidExprSyntax(expression)
        }
        guard let declarationReferenceExpression = nestedExpression.as(DeclReferenceExprSyntax.self) else {
            throw ParserError.invalidExprSyntax(expression)
        }

        return declarationReferenceExpression.baseName
    }

    private static func parseClassNominalTypeSyntax(declaration: DeclSyntaxProtocol) -> NominalTypeSyntax? {
        if let declaration = declaration.as(ClassDeclSyntax.self) {
            return NominalTypeSyntax(
                modifiers: declaration.modifiers,
                name: declaration.name,
                inheritanceClause: declaration.inheritanceClause
            )
        }

        return nil
    }

    private static func parseConcreteNominalTypeSyntax(declaration: DeclSyntaxProtocol) -> NominalTypeSyntax? {
        if let nominalType = self.parseClassNominalTypeSyntax(declaration: declaration) {
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

    static func parseConcreteNominalTypeSyntax(declaration: DeclSyntaxProtocol) throws -> NominalTypeSyntax {
        if let nominalType = self.parseConcreteNominalTypeSyntax(declaration: declaration) {
            return nominalType
        }

        throw ParserError.invalidDeclSyntax(declaration)
    }

    static func parseNominalTypeSyntax(declaration: DeclSyntaxProtocol) throws -> NominalTypeSyntax {
        if let nominalType = self.parseConcreteNominalTypeSyntax(declaration: declaration) {
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
