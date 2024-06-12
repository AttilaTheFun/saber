import SwiftSyntax

// MARK: ConcreteDeclType

public enum ConcreteDeclType {
    case actorType
    case classType
    case structType
}

// MARK: ConcreteDeclSyntaxProtocol

public protocol ConcreteDeclSyntaxProtocol: SyntaxProtocol {
    var attributes: AttributeListSyntax { get set }
    var modifiers: DeclModifierListSyntax { get set }
    var inheritanceClause: InheritanceClauseSyntax? { get set }
    var name: TokenSyntax { get set }
    var type: ConcreteDeclType { get }
}

extension ActorDeclSyntax: ConcreteDeclSyntaxProtocol {
    public var type: ConcreteDeclType {
        return .actorType
    }
}
extension ClassDeclSyntax: ConcreteDeclSyntaxProtocol {
    public var type: ConcreteDeclType {
        return .classType
    }
}
extension StructDeclSyntax: ConcreteDeclSyntaxProtocol {
    public var type: ConcreteDeclType {
        return .structType
    }
}
