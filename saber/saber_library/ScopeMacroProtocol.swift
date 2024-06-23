import SaberTypes
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ScopeMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
    case invalidProperty
    case invalidComputedPropertyName
    case invalidComputedPropertyType
}

public protocol ScopeMacroProtocol: ExtensionMacro, MemberMacro, PeerMacro {}

extension ScopeMacroProtocol {

    // MARK: ExtensionMacro

    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        // Create the extension declaration:
        let extensionDeclaration = try self.extensionDeclaration(
            declaration: declaration,
            type: type
        )

        return [extensionDeclaration]
    }

    private static func extensionDeclaration(
        declaration: some DeclGroupSyntax,
        type: some TypeSyntaxProtocol
    ) throws -> ExtensionDeclSyntax {

        // Create the member block:
        let memberBlockItemList = MemberBlockItemListSyntax([])
        let memberBlock = MemberBlockSyntax(members: memberBlockItemList)

        // Create the extension declaration:
        let inheritedProtocolType = TypeSyntax(stringLiteral: "ArgumentsAndDependenciesInitializable")
        let inheritedType = InheritedTypeSyntax(type: inheritedProtocolType)
        let inheritedTypeList = InheritedTypeListSyntax([inheritedType])
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
        let extensionDeclaration = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )

        return extensionDeclaration
    }

    // MARK: MemberMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext) throws
        -> [DeclSyntax]
    {
        // Walk the declaration with the visitor:
        let visitor = DeclarationVisitor()
        visitor.walk(declaration)

        // Create the member declarations:
        var memberDeclarations = [DeclSyntax]()
        memberDeclarations += try self.parentTypeAliasDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )
        memberDeclarations += try self.parentPropertyDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )

        // If there there is *not* a handwritten initializer we need to generate it:
        let shouldGenerateInitializer = visitor.initArgumentsAndDependenciesDeclaration == nil
        if shouldGenerateInitializer {
            let memberDeclaration = try self.parentInitializerDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
            memberDeclarations.append(memberDeclaration)
        }

        return memberDeclarations
    }

    private static func parentTypeAliasDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        var typeAliasDeclarations = [DeclSyntax]()

        // If there is not a handwritten arguments type alias declaration, we need to create one:
        if visitor.argumentsTypeAliasDeclaration == nil {

            // Determine the arguments type:
            let argumentsType: String
            if visitor.argumentProperties.count > 0 {
                // If we have argument properties,
                // we infer the Arguments type name is the concrete type name with the Arguments suffix.
                argumentsType = "\(concreteDeclaration.name.trimmed)Arguments"
            } else {
                // If there are no argument properties,
                // we infer the Arguments type to be Void.
                argumentsType = "Void"
            }

            // Create the arguments type alias declaration:
            let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
            let argumentsTypeAliasDeclaration: DeclSyntax =
            """
            \(raw: accessLevel) typealias Arguments = \(raw: argumentsType)
            """
            typeAliasDeclarations.append(argumentsTypeAliasDeclaration)
        }

        return typeAliasDeclarations
    }

    private static func parentPropertyDeclarations(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the property declarations:
        var propertyDeclarations = [DeclSyntax]()

        // TODO: Do we still need this?
        // let fulfilledDependenciesReferenceType = node.fulfilledDependenciesReferenceTypeArgument ?? .weak

        // Create the fulfilled dependencies property declarations:
        let fulfilledDependenciesClassName = "\(concreteDeclaration.name.trimmed)FulfilledDependencies"
        propertyDeclarations += [
            "private weak var _fulfilledDependencies: \(raw: fulfilledDependenciesClassName)?",
            "private let _fulfilledDependenciesLock = Lock()",
            """
            fileprivate var fulfilledDependencies: \(raw: fulfilledDependenciesClassName) {
            if let fulfilledDependencies = self._fulfilledDependencies {
            return fulfilledDependencies
            }
            self._fulfilledDependenciesLock.lock()
            defer { self._fulfilledDependenciesLock.unlock() }
            if let fulfilledDependencies = self._fulfilledDependencies {
            return fulfilledDependencies
            }
            let fulfilledDependencies = \(raw: fulfilledDependenciesClassName)(parent: self)
            self._fulfilledDependencies = fulfilledDependencies
            return fulfilledDependencies
            }
            """
        ]

        // Create the arguments stored property declaration:
        let argumentsPropertyDeclaration: DeclSyntax =
        """
        private let _arguments: Arguments
        """
        propertyDeclarations.append(argumentsPropertyDeclaration)

        return propertyDeclarations
    }

    private static func parentInitializerDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) init(arguments: Arguments, dependencies: any Dependencies) {
            self._arguments = arguments
            self._dependencies = dependencies
        }
        """

        return initializerDeclaration
    }

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Walk the declaration with the visitor:
        let visitor = DeclarationVisitor()
        visitor.walk(declaration)

        // Create the protocol declarations:
        let declarations: [DeclSyntax?] = [
            try self.fulfilledDependenciesClassDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
        ]

        return declarations.compactMap { $0 }
    }

    private static func fulfilledDependenciesClassDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Extract the dependencies protocol names from the factory and store properties:
        var fulfilledDependenciesProtocolNames = [String]()
        for (_, attributeSyntax) in visitor.fulfillProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            let fulfilledDependenciesProtocolName = concreteTypeDescription.asSource
            fulfilledDependenciesProtocolNames.append(fulfilledDependenciesProtocolName)
        }

        // Create the inheritance clause:
        var inheritanceClause: InheritanceClauseSyntax?
        if fulfilledDependenciesProtocolNames.count > 0 {
            let inheritedTypes = fulfilledDependenciesProtocolNames.enumerated().map { index, protocolName in
                let trailingComma: TokenSyntax? = index < (fulfilledDependenciesProtocolNames.endIndex - 1) ?
                    TokenSyntax.commaToken() : nil
                return InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolName), trailingComma: trailingComma)
            }
            let inheritedTypeList = InheritedTypeListSyntax(inheritedTypes)
            inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
        }

        // Create the member block:
        let propertyDeclarations =
            try self.fulfilledDependenciesPropertyDeclarations(visitor: visitor, declaration: declaration)
        let initializerDeclaration = 
            try self.fulfilledDependenciesInitializerDeclaration(visitor: visitor, declaration: declaration)
        let memberDeclarations = propertyDeclarations + [initializerDeclaration]
        let memberBlockItems = memberDeclarations.map { memberDeclaration in
            return MemberBlockItemSyntax(decl: memberDeclaration)
        }
        let memberBlockItemList = MemberBlockItemListSyntax(memberBlockItems)
        let memberBlock = MemberBlockSyntax(members: memberBlockItemList)

        // Create the child dependencies class declaration:
        let fulfilledDependenciesClassName = "\(concreteDeclaration.name.trimmed)FulfilledDependencies"
        let classDeclaration = ClassDeclSyntax(
            modifiers: DeclModifierListSyntax([
                DeclModifierSyntax(
                    // TODO: Do we need this?
                    // name: TokenSyntax(stringLiteral: concreteDeclaration.modifiers.accessLevel.rawValue)
                    name: TokenSyntax(stringLiteral: "fileprivate")
                ),
                DeclModifierSyntax(
                    name: TokenSyntax(stringLiteral: "final")
                )
            ]),
            name: TokenSyntax(stringLiteral: fulfilledDependenciesClassName),
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )

        return DeclSyntax(classDeclaration)
    }

    private static func fulfilledDependenciesPropertyDeclarations(
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the property declarations:
        var propertyDeclarations = [DeclSyntax]()

        // Create the parent stored property declaration:
        let parentName = "\(concreteDeclaration.name.trimmed)"
        let parentPropertyDeclaration: DeclSyntax =
        """
        private let _parent: \(raw: parentName)
        """
        propertyDeclarations.append(parentPropertyDeclaration)

        // Create the computed property declarations for all of the properties, reading their values from the parent:
        for property in visitor.allProperties {
            guard let typeDescription = property.typeDescription else {
                throw ScopeMacroProtocolError.invalidProperty
            }

            // Create the stored property declaration:
            let propertyDeclaration: DeclSyntax =
            """
            fileprivate var \(raw: property.label): \(raw: typeDescription.asSource) {
                return self._parent.\(raw: property.label)
            }
            """
            propertyDeclarations.append(propertyDeclaration)
        }

        return propertyDeclarations
    }

    private static func fulfilledDependenciesInitializerDeclaration(
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer:
        let initializerDeclaration: DeclSyntax =
        """
        fileprivate init(parent: \(concreteDeclaration.name.trimmed)) {
            self._parent = parent
        }
        """

        return initializerDeclaration
    }
}
