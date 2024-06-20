import SwiftSyntax

extension InheritanceClauseSyntax {
    var scopeTypeDescription: TypeDescription? {
        for inheritedType in self.inheritedTypes {
            let inheritedTypeDescription = inheritedType.type.typeDescription
            guard case .simple(let name, _) = inheritedTypeDescription, name == "Scope" else {
                continue
            }

            return inheritedTypeDescription
        }

        return nil
    }
}
