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

public protocol InjectableMacroProtocol: MemberMacro, PeerMacro {}

extension InjectableMacroProtocol {

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
                visitor: visitor,
                declaration: declaration
            ),
            try self.childDependenciesClassDeclaration(
                visitor: visitor,
                declaration: declaration
            )
        ]

        return declarations.compactMap { $0 }
    }

    private static func dependenciesProtocolDeclaration(
        visitor: InjectableVisitor,
        declaration: some DeclSyntaxProtocol
    ) throws -> DeclSyntax? {
        guard let concreteDeclaration = visitor.concreteDeclaration else {
            throw InjectableMacroProtocolError.declarationNotConcrete
        }

        // Create properties for the protocol:
        var protocolProperties = [String]()
        for (property, _) in visitor.injectProperties {
            let protocolProperty = "var \(property.label): \(property.typeDescription.asSource) { get }"
            protocolProperties.append(protocolProperty)
        }
        let protocolBody = protocolProperties.joined(separator: "\n")

        // Create the child dependencies protocol declaration:
        let dependenciesProtocolName = "\(concreteDeclaration.name.trimmed)Dependencies"
        let dependenciesProtocolDeclaration: DeclSyntax =
        """
        \(raw: concreteDeclaration.modifiers.accessLevel.rawValue) protocol \(raw: dependenciesProtocolName): AnyObject {
        \(raw: protocolBody)
        }
        """

        return dependenciesProtocolDeclaration
    }

    private static func childDependenciesClassDeclaration(
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
        var concreteTypeDescriptions = [TypeDescription]()
        for (_, attributeSyntax) in visitor.childDependencyProperties {
            guard let concreteTypeDescription = attributeSyntax.concreteTypeArgument else {
                throw InjectableMacroProtocolError.invalidMacroArguments
            }

            concreteTypeDescriptions.append(concreteTypeDescription)
        }

        // Create the inheritance clause:
        let dependenciesProtocolName = "\(concreteDeclaration.name.trimmed)Dependencies"
        let childDependenciesProtocolNames = concreteTypeDescriptions
            .map { $0.asSource + "Dependencies" }
            .sorted()
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

        // Create the declarations:
        let propertyDeclarations = try self.parentPropertyDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )
        let initializerDeclarations = try self.parentInitializerDeclarations(
            node: node,
            visitor: visitor,
            declaration: declaration
        )

        return propertyDeclarations + initializerDeclarations
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

        // Create the arguments stored property declaration if necessary:
        if let (property, _) = visitor.argumentsProperty {
            let propertyDeclaration: DeclSyntax =
            """
            private let _arguments: \(raw: property.typeDescription.asSource)
            """
            propertyDeclarations.append(propertyDeclaration)
        }

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
                accessorLine: "return \(concreteType.asSource)(dependencies: self._childDependenciesStore.building)"
            )
            propertyDeclarations.append(propertyDeclaration)
        }

        // Check if we have any child dependencies and create the associated property declarations if so:
        if visitor.childDependencyProperties.count > 0 {
            let childDependenciesClassName = "\(concreteDeclaration.name.trimmed)ChildDependencies"
            let injectableType = node.injectableTypeArgument ?? .strong

            // Create the stored property declaration:
            let propertyDeclaration = self.parentStoredPropertyDeclaration(
                propertyLabel: "childDependencies",
                storageStrategy: injectableType == .root ? .strong : .weak,
                accessorLine: "return \(childDependenciesClassName)(parent: self)"
            )
            propertyDeclarations.append(propertyDeclaration)
        }

        // Create the dependencies stored property declaration:
        let injectableType = node.injectableTypeArgument ?? .strong
        let bindingModifier = injectableType == .unowned ? "unowned " : ""
        let dependenciesProtocolName = "\(concreteDeclaration.name.trimmed)Dependencies"
        let dependenciesPropertyDeclaration: DeclSyntax =
        """
        private \(raw: bindingModifier)let _dependencies: any \(raw: dependenciesProtocolName)
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

        // Create the initializer arguments:
        var initializerArguments = [String]()
        if let (property, _) = visitor.argumentsProperty {
            initializerArguments.append("arguments: \(property.typeDescription.asSource)")
        }
        initializerArguments.append("dependencies: any \(concreteDeclaration.name.trimmed)Dependencies")

        // Create the initializer lines:
        var initializerLines = [String]()
        if visitor.argumentsProperty != nil {
            initializerLines.append("self._arguments = arguments")
        }
        initializerLines.append("self._dependencies = dependencies")

        // Call the designated initializer and implement the required initializer, if necessary:
        var requiredInitializers = [DeclSyntax]()
        switch node.injectableTypeArgument ?? .strong {
        case .strong, .unowned, .root:
            break
        case .viewController:
            initializerLines.append("super.init(nibName: nil, bundle: nil)")
            requiredInitializers = [
                """
                required init?(coder: NSCoder) {
                    fatalError("not implemented")
                }
                """
            ]
        case .view:
            initializerLines.append("super.init(frame: .zero)")
            requiredInitializers = [
                """
                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
                """
            ]
        }

        // Invoke eager store properties:
        for (property, attributeSyntax) in visitor.storeProperties {
            guard case .eager = attributeSyntax.initializationStrategyArgument ?? .lazy else {
                continue
            }

            initializerLines.append("_ = self.\(property.label)")
        }

        // Create the initializer:
        let initializerDeclaration: DeclSyntax =
        """
        \(raw: concreteDeclaration.modifiers.accessLevel.rawValue) init(
        \(raw: initializerArguments.joined(separator: ",\n"))
        ) {
        \(raw: initializerLines.joined(separator: "\n"))
        }
        """

        return [initializerDeclaration] + requiredInitializers
    }
}
