import DependencyFoundation

public final class RootScope: BaseScope {
    public override init() {
        super.init()
    }
}

// FooServiceProvider

import FooServiceInterface

extension RootScope: FooServiceProvider {}

// FooServiceImplementationProvider

import FooServiceImplementation

extension RootScope: FooServiceImplementationProvider {}

// BarServiceProvider

import BarServiceInterface

extension RootScope: BarServiceProvider {}

// BarServiceImplementationProvider

import BarServiceImplementation

extension RootScope: BarServiceImplementationProvider {}