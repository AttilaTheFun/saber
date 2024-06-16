import SwiftDiagnostics
import SwiftSyntax

public final class InjectableVisitor: SyntaxVisitor {

    // MARK: Initialization

    public init() {
        super.init(viewMode: .sourceAccurate)
    }

    // MARK: Properties

    private(set) var isTopLevelDeclaration = true

    public private(set) var diagnostics = [Diagnostic]()
    public private(set) var concreteDeclaration: ConcreteDeclSyntaxProtocol?

    public private(set) var argumentsProperty: (Property,AttributeSyntax)?
    public private(set) var injectProperties: [(Property,AttributeSyntax)] = []
    public private(set) var factoryProperties: [(Property,AttributeSyntax)] = []
    public private(set) var storeProperties: [(Property,AttributeSyntax)] = []

    public var childDependencyProperties: [(Property,AttributeSyntax)] {
        return self.factoryProperties + self.storeProperties
    }

    public var allProperties: [(Property,AttributeSyntax)] {
        return [self.argumentsProperty].compactMap { $0 } +
            self.injectProperties + self.factoryProperties + self.storeProperties
    }

    // MARK: Concrete Declarations

    public override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        return self.visitConcreteDecl(node)
    }

    public override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        return self.visitConcreteDecl(node)
    }

    public override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        return self.visitConcreteDecl(node)
    }

    private func visitConcreteDecl(_ node: some ConcreteDeclSyntaxProtocol) -> SyntaxVisitorContinueKind {
        if !self.isTopLevelDeclaration {
            return .skipChildren
        }

        self.isTopLevelDeclaration = false
        self.concreteDeclaration = node
        return .visitChildren
    }

    // MARK: Variable Declarations

    public override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.modifiers.isStatic {
            return .skipChildren
        }

        guard let injectableMacroType = node.attributes.injectableMacroType else {
            return .skipChildren
        }

        // Ensure that this is a single binding variable declaration:
        if node.bindings.count > 1 {
            // TODO: Diagnostic.
            fatalError()
        }

        // Check that the binding specifier is a var:
        if node.bindingSpecifier.text != "var" {
            // TODO: Diagnostic.
            fatalError()
        }

        for binding in node.bindings {

            // Check that each binding has no initializer.
            if binding.initializer != nil {
                // TODO: Diagnostic.
                fatalError()
            }

            // Parse the property:
            if
                let identifierPattern = IdentifierPatternSyntax(binding.pattern),
                let typeAnnotation = binding.typeAnnotation
            {

                // Parse the type description:
                let typeDescription = typeAnnotation.type.typeDescription
                if case .unknown(let description) = typeDescription {
                    // TODO: Diagnostic.
                    fatalError(description)
                }
                
                let property = Property(
                    accessLevel: node.modifiers.accessLevel,
                    label: identifierPattern.identifier.text,
                    typeDescription: typeDescription
                )
                switch injectableMacroType {
                case .arguments(let attributeSyntax):
                    self.argumentsProperty = (property, attributeSyntax)
                case .inject(let attributeSyntax):
                    self.injectProperties.append((property, attributeSyntax))
                case .factory(let attributeSyntax):
                    self.factoryProperties.append((property, attributeSyntax))
                case .store(let attributeSyntax):
                    self.storeProperties.append((property, attributeSyntax))
                }
            } else {
                // TODO: Diagnostic.
                fatalError()
            }
        }

        return .skipChildren
    }
}
