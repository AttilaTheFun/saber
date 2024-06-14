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

    public private(set) var argumentsProperty: Property?
    public private(set) var injectProperties: [Property] = []
    public private(set) var factoryProperties: [(Property,AttributeSyntax)] = []
    public private(set) var storeProperties: [(Property,AttributeSyntax)] = []

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

        if node.bindings.count > 1 {
            // TODO: Figure out if this can happen?
            // Maybe multiple variable binding like:
            // let (foo, bar) = functionThatReturnsTyple()
            fatalError("Does this happen?")
        }

        for binding in node.bindings {

            // Check that each variable has no initializer.
            if binding.initializer != nil {
                // TODO: Diagnostic.
                fatalError()
            }

            // Parse the property:
            if
                let identifierPatternSyntax = binding.pattern.as(IdentifierPatternSyntax.self),
                let typeAnnotationSyntax = binding.typeAnnotation
            {
                let label = identifierPatternSyntax.identifier.text

                // Parse the type description:
                let typeDescription = typeAnnotationSyntax.type.typeDescription
                if case .unknown(let description) = typeDescription {
                    // TODO: Diagnostic.
                    fatalError(description)
                }
                
                let property = Property(label: label, typeDescription: typeDescription)
                switch injectableMacroType {
                case .arguments:
                    self.argumentsProperty = property
                case .inject:
                    self.injectProperties.append(property)
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
