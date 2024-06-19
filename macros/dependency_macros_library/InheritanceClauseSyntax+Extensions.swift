import SwiftSyntax

extension InheritanceClauseSyntax {
    var scopeTypeDescription: TypeDescription? {
        for inheritedType in self.inheritedTypes {
            let inheritedTypeDescription = inheritedType.type.typeDescription
            guard 
                case .simple(let name, let generics) = inheritedTypeDescription,
                name == "Scope",
                generics.count == 2 else
            {
                continue
            }

            return inheritedTypeDescription
        }

        return nil
    }
}
