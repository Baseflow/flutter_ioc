## 2.0.0

* **BREAKING CHANGE:** Removes the hard dependency on `get_it`, which means:
    * Developers manually need to register an implementation of the `IocContainer` class using the `IocContainer.registerContainer` method.
    * The `IocContainer.container` field will no longer return a default implementation.

## 1.2.0

* Adds support for creating and removing scopes to the IoC container.
* Adds support to reset a registered lazy-singleton. Resetting a lazy-singleton
will instruct the IoC container to create a new instance of the lazy-singleton
next time it is accessed.
* Allows support for registering a `onDispose` callback for singleton and
lazy-singleton registrations. This callback will be called when a singleton or
lazy-singleton is destroyed and could be used to clean up additional resources.


## 1.1.0

* Adds support for reassigning registrations that were made earlier.

## 1.0.0

* Initial version.  
