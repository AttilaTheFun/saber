import DependencyMacrosTypes
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum InjectableMacroProtocolError: Error {
    case declarationNotConcrete
    case invalidMacroArguments
    case invalidComputedPropertyName
    case invalidComputedPropertyType
}

public protocol InjectableMacroProtocol: ExtensionMacro, MemberMacro, PeerMacro {}

extension InjectableMacroProtocol {

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
        let injectableProtocolType = TypeSyntax(stringLiteral: "Injectable")
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
        let visitor = InjectableVisitor()
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
        if visitor.initializerDeclaration == nil {
            memberDeclarations += try self.parentInitializerDeclarations(
                node: node,
                visitor: visitor,
                declaration: declaration
            )
        }

        return memberDeclarations
    }

    private static func parentTypeAliasDeclarations(
        node: AttributeSyntax,
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        var typeAliasDeclarations = [DeclSyntax]()

        // If there is not a handwritten arguments type alias declaration, we need to create one:
        if visitor.argumentsTypeAliasDeclaration == nil {

            // Determine the arguments type:
            let argumentsType: String
            if
                concreteDeclaration.inheritanceClause?.scopeTypeDescription != nil,
                let (rootFactoryProperty, _) = visitor.factoryProperties.first(where: { $0.0.label == "rootFactory" }),
                case .any(let typeDescription) = rootFactoryProperty.typeDescription,
                case .simple(_, let generics) = typeDescription,
                generics.count == 2
            {
                // If the concrete type inherits from the Scope type,
                // we infer the Arguments type from the first generic argument.
                argumentsType = generics[0].asSource
            } else if visitor.argumentProperties.count > 0 {
                // If we have argument properties,
                // we infer the Arguments type name is the concrete type name with the Arguments suffix.
                argumentsType = "\(concreteDeclaration.name.trimmed)Arguments"
            } else {
                // If there are no argument properties,
                // we infer the Arguments type to be Any.
                argumentsType = "Any"
            }

            // Create the arguments type alias declaration:
            let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
            let argumentsTypeAliasDeclaration: DeclSyntax =
            """
            \(raw: accessLevel) typealias Arguments = \(raw: argumentsType)
            """
            typeAliasDeclarations.append(argumentsTypeAliasDeclaration)
        }

        // If there is not a handwritten dependencies type alias declaration, we need to create one:
        if visitor.dependenciesTypeAliasDeclaration == nil {
            let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
                "UnownedDependencies" : "Dependencies"
            let dependenciesProtocolName = concreteDeclaration.name.trimmed.text + dependenciesSuffix
            let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
            let dependenciesTypeAliasDeclaration: DeclSyntax =
            """
            \(raw: accessLevel) typealias \(raw: dependenciesSuffix) = \(raw: dependenciesProtocolName)
            """
            typeAliasDeclarations.append(dependenciesTypeAliasDeclaration)
        }

        return typeAliasDeclarations
    }

    private static func parentPropertyDeclarations(
        node: AttributeSyntax,
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create the property declarations:
        var propertyDeclarations = [DeclSyntax]()

        // Create the inject property declarations if necessary:
        for (property, attributeSyntax) in visitor.injectProperties {
            let propertyDeclaration = self.parentStoredPropertyDeclaration(
                propertyLabel: property.label,
                storageStrategy: attributeSyntax.storageStrategyArgument ?? .strong,
                accessorLine: "return self._dependencies.\(property.label)"
            )
            propertyDeclarations.append(propertyDeclaration)
        }

        // Create the store property declarations if necessary:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard let concreteType = attributeSyntax.concreteTypeArgument else {
                throw InjectableMacroProtocolError.invalidMacroArguments
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
        let argumentsPropertyDeclaration: DeclSyntax =
        """
        private let _arguments: Arguments
        """
        propertyDeclarations.append(argumentsPropertyDeclaration)

        // Create the dependencies stored property declaration:
        let dependenciesReferenceType = node.dependenciesReferenceTypeArgument ?? .strong
        let dependenciesSuffix = dependenciesReferenceType == .unowned ? "UnownedDependencies" : "Dependencies"
        let bindingModifier = dependenciesReferenceType == .unowned ? "unowned " : ""
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private \(raw: bindingModifier)let _dependencies: any \(raw: dependenciesSuffix)
        """
        propertyDeclarations.append(dependenciesPropertyDeclaration)

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

    private static func parentInitializerDeclarations(
        node: AttributeSyntax,
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create the initializer lines:
        var initializerLines = [
            "self._arguments = arguments",
            "self._dependencies = dependencies",
        ]

        // Call the designated initializer and implement the required initializers, if necessary:
        var requiredInitializers = [DeclSyntax]()
        if let superTypeArgument = node.superTypeArgument {
            switch superTypeArgument.asSource {
            case "UIViewController":
                initializerLines.append("super.init(nibName: nil, bundle: nil)")
                requiredInitializers = [
                    """
                    required init?(coder: NSCoder) {
                        fatalError("init(coder:) has not been implemented")
                    }
                    """
                ]
            case "UIView":
                initializerLines.append("super.init(frame: .zero)")
                requiredInitializers = [
                    """
                    required init?(coder: NSCoder) {
                        fatalError("init(coder:) has not been implemented")
                    }
                    """
                ]
            default:
                // TODO: Diagnostic
                fatalError()
            }
        }

        // Invoke eager store properties:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard case .eager = attributeSyntax.initializationStrategyArgument ?? .lazy else {
                continue
            }

            initializerLines.append("_ = self.\(property.label)")
        }

        // Create the initializer:
        let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
            "UnownedDependencies" : "Dependencies"
        let accessLevel = concreteDeclaration.modifiers.accessLevel.rawValue
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: accessLevel) init(arguments: Arguments, dependencies: \(raw: dependenciesSuffix)) {
        \(raw: initializerLines.joined(separator: "\n"))
        }
        """

        return [initializerDeclaration] + requiredInitializers
    }

    // MARK: PeerMacro

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Walk the declaration with the visitor:
        let visitor = InjectableVisitor()
        visitor.walk(declaration)

        // Create the protocol declarations:
        let declarations: [DeclSyntax?] = [
            try self.dependenciesProtocolDeclaration(
                node: node,
                visitor: visitor,
                declaration: declaration
            ),
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
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
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
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // If the visitor does not have any properties with child dependencies, return early:
        guard visitor.childDependencyProperties.count > 0 else {
            return nil
        }

        // Extract the concrete type descriptions from the @Store and @Factory arguments:
        var childDependenciesProtocolNames = [String]()
        for (_, attributeSyntax) in visitor.factoryProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw InjectableMacroProtocolError.invalidMacroArguments
            }

            let childDependenciesSuffix = "Dependencies"
            let childDependenciesProtocolName = concreteTypeDescription.asSource + "." + childDependenciesSuffix
            childDependenciesProtocolNames.append(childDependenciesProtocolName)
        }
        for (_, attributeSyntax) in visitor.storeProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw InjectableMacroProtocolError.invalidMacroArguments
            }

            let storageStrategyArgument = attributeSyntax.storageStrategyArgument ?? .strong
            let childDependenciesSuffix = storageStrategyArgument == .strong ?
                "UnownedDependencies" : "Dependencies"
            let childDependenciesProtocolName = concreteTypeDescription.asSource + "." + childDependenciesSuffix
            childDependenciesProtocolNames.append(childDependenciesProtocolName)
        }

        // Create the inheritance clause:
        let dependenciesSuffix = (node.dependenciesReferenceTypeArgument ?? .strong) == .unowned ?
            "UnownedDependencies" : "Dependencies"
        let dependenciesProtocolName = concreteDeclaration.name.trimmed.text + "." + dependenciesSuffix
        let allProtocolNames = [dependenciesProtocolName] + childDependenciesProtocolNames
        let inheritedTypes = allProtocolNames.enumerated().map { index, protocolName in
            let trailingComma: TokenSyntax? = index < (allProtocolNames.endIndex - 1) ?
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
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> [DeclSyntax] {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
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
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
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
