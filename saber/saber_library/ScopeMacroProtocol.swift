import SaberTypes
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ScopeMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
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
        let injectableProtocolType = TypeSyntax(stringLiteral: "Scope")
        let inheritedType = InheritedTypeSyntax(type: injectableProtocolType)
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
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

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
        let isInjectable = concreteDeclaration.attributes.injectableMacro != nil
        let shouldGenerateInitializer = isInjectable ?
            visitor.initArgumentsDependenciesDeclaration == nil :
            visitor.initArgumentsDeclaration == nil
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

        // Create the store property declarations if necessary:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard let concreteType = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            let propertyDeclaration = self.parentStoredPropertyDeclaration(
                propertyLabel: property.label,
                storageStrategy: attributeSyntax.storageStrategyArgument ?? .strong,
                accessorLine: "return \(concreteType.asSource)(dependencies: self._childDependenciesStore.value)"
            )
            propertyDeclarations.append(propertyDeclaration)
        }

        // Check if we have any child dependencies and create the associated property declarations if so:
        if visitor.childDependencyProperties.count > 0 {
            let childDependenciesClassName = "\(concreteDeclaration.name.trimmed)ChildDependencies"

            // Create the stored property declaration:
            let childDependenciesReferenceType = node.childDependenciesReferenceTypeArgument ?? .weak
            let propertyDeclaration = self.parentStoredPropertyDeclaration(
                propertyLabel: "childDependencies",
                storageStrategy: childDependenciesReferenceType == .weak ? .weak : .strong,
                accessorLine: "return \(childDependenciesClassName)(parent: self)"
            )
            propertyDeclarations.append(propertyDeclaration)
        }

        // Create the arguments stored property declaration:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let argumentsPropertyDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) let arguments: Arguments
        """
        propertyDeclarations.append(argumentsPropertyDeclaration)

        return propertyDeclarations
    }

    private static func parentStoredPropertyDeclaration(
        propertyLabel: String,
        storageStrategy: StorageStrategy,
        accessorLine: String
    ) -> DeclSyntax {

        // If this is a purely computed property, we don't need a backing stored property.
        let backingStore: String
        switch storageStrategy {
        case .strong:
            backingStore = "StrongBackingStoreImplementation()"
        case .weak:
            backingStore = "WeakBackingStoreImplementation()"
        case .computed:
            backingStore = "ComputedBackingStoreImplementation()"
        }

        // Create the stored property declaration:
        let propertyDeclaration: DeclSyntax =
        """
        private lazy var _\(raw: propertyLabel)Store = StoreImplementation(
            backingStore: \(raw: backingStore),
            function: { [unowned self] in
                \(raw: accessorLine)
            }
        )
        """

        return propertyDeclaration
    }

    private static func parentInitializerDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer lines:
        var initializerParameters = ["arguments: Arguments"]
        var initializerLines = ["self.arguments = arguments"]

        // If the concrete type is *also* annotated with the @Injectable macro, we need to include the dependencies:
        if concreteDeclaration.attributes.injectableMacro != nil {
            initializerParameters.append("dependencies: any Dependencies")
            initializerLines.append("self.dependencies = dependencies")
        }

        // Invoke eager store properties:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard case .eager = attributeSyntax.initializationStrategyArgument ?? .lazy else {
                continue
            }

            initializerLines.append("_ = self.\(property.label)")
        }

        // Create the initializer:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) init(\(raw: initializerParameters.joined(separator: ", "))) {
        \(raw: initializerLines.joined(separator: "\n"))
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
            try self.childDependenciesClassDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
        ]

        return declarations.compactMap { $0 }
    }

    private static func dependenciesProtocolDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // If the visitor has a handwritten dependencies type alias, return early:
        if visitor.dependenciesTypeAliasDeclaration != nil {
            return nil
        }

        // Create properties for the protocol:
        var protocolProperties = [String]()
        for (property, _) in visitor.injectProperties {
            let protocolProperty = "var \(property.label): \(property.typeDescription.asSource) { get }"
            protocolProperties.append(protocolProperty)
        }
        let protocolBody = protocolProperties.joined(separator: "\n")

        // Create the child dependencies protocol declaration:
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
            "UnownedDependencies" : "Dependencies"
        let dependenciesProtocolName = concreteDeclaration.name.trimmed.text + dependenciesSuffix
        let dependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) protocol \(raw: dependenciesProtocolName): AnyObject {\(raw: protocolBody)}
        """

        return dependenciesProtocolDeclaration
    }

    private static func childDependenciesClassDeclaration(
        node: AttributeSyntax,
        visitor: DeclarationVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw ScopeMacroProtocolError.declarationNotConcrete
        }

        // If the visitor does not have any properties with child dependencies, return early:
        guard visitor.childDependencyProperties.count > 0 else {
            return nil
        }

        // Extract the dependencies protocol names from the factory and store properties:
        var childDependenciesProtocolNames = [String]()
        for (_, attributeSyntax) in visitor.factoryProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            let childDependenciesSuffix = "Dependencies"
            let childDependenciesProtocolName = concreteTypeDescription.asSource + "." + childDependenciesSuffix
            childDependenciesProtocolNames.append(childDependenciesProtocolName)
        }
        for (_, attributeSyntax) in visitor.storeProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw ScopeMacroProtocolError.invalidMacroArguments
            }

            let storageStrategyArgument = attributeSyntax.storageStrategyArgument ?? .strong
            let childDependenciesSuffix = storageStrategyArgument == .strong ?
                "UnownedDependencies" : "Dependencies"
            let childDependenciesProtocolName = concreteTypeDescription.asSource + "." + childDependenciesSuffix
            childDependenciesProtocolNames.append(childDependenciesProtocolName)
        }

        // Create the inheritance clause:
        let inheritedTypes = childDependenciesProtocolNames.enumerated().map { index, protocolName in
            let trailingComma: TokenSyntax? = index < (childDependenciesProtocolNames.endIndex - 1) ?
                TokenSyntax.commaToken() : nil
            return InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolName), trailingComma: trailingComma)
        }
        let inheritedTypeList = InheritedTypeListSyntax(inheritedTypes)
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)

        // Create the member block:
        let propertyDeclarations =
            try self.childDependenciesPropertyDeclarations(visitor: visitor, declaration: declaration)
        let initializerDeclaration = 
            try self.childDependenciesInitializerDeclaration(visitor: visitor, declaration: declaration)
        let memberDeclarations = propertyDeclarations + [initializerDeclaration]
        let memberBlockItems = memberDeclarations.map { memberDeclaration in
            return MemberBlockItemSyntax(decl: memberDeclaration)
        }
        let memberBlockItemList = MemberBlockItemListSyntax(memberBlockItems)
        let memberBlock = MemberBlockSyntax(members: memberBlockItemList)

        // Create the child dependencies class declaration:
        let childDependenciesClassName = "\(concreteDeclaration.name.trimmed)ChildDependencies"
        let classDeclaration = ClassDeclSyntax(
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(
                    name: TokenSyntax(stringLiteral: "fileprivate")
                )
            },
            name: TokenSyntax(stringLiteral: childDependenciesClassName),
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )

        return DeclSyntax(classDeclaration)
    }

    private static func childDependenciesPropertyDeclarations(
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
        for (property, _) in visitor.allProperties {

            // Create the stored property declaration:
            let propertyDeclaration: DeclSyntax =
            """
            fileprivate var \(raw: property.label): \(raw: property.typeDescription.asSource) {
                return self._parent.\(raw: property.label)
            }
            """
            propertyDeclarations.append(propertyDeclaration)
        }

        return propertyDeclarations
    }

    private static func childDependenciesInitializerDeclaration(
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
