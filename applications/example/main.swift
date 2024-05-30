import FooServiceInterface
import FooServiceImplementation
import BarServiceInterface
import BarServiceImplementation
import RootScopeImplementation

let rootScope = RootScope()

print(ObjectIdentifier(rootScope.fooService as! AnyObject))
print(ObjectIdentifier(rootScope.fooService as! AnyObject))
print(ObjectIdentifier(rootScope.barService as! AnyObject))
print(ObjectIdentifier(rootScope.barService as! AnyObject))