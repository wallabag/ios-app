//
//  Injector.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/10/2019.
//

import Swinject

@propertyWrapper
struct Injector<Service> {
    var service: Service?
    var container: Resolver?

    var wrappedValue: Service {
        mutating get {
            if service == nil {
                service = DependencyInjection.container.resolve(Service.self)
            }

            return service!
        }
    }
}
