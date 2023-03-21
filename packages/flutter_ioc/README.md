# flutter_ioc

A standard interface providing inversion of control services to Dart or Flutter
applications.

This interface allows developers to add inversion of control to their 
applications or libraries without having to tightly couple to a specific 
package.

## Usage

To implement a new specific inversion of control implementation, extend
`IocContainer` with an implementation that performs the inversion of control
behavior, and add a static `register` method that will register the 
implementation with the `IocContainer` library:

```dart
class MyIocContainer extends IocContainer {
  static void register() {
    IocContainer.registerContainer()
  }

  /// Hide the public constructor to promote the usage of the 
  /// [IocContainer.container] API.
  ///
  /// This prevents tightly coupling on the [MyIocContainer]
  /// class.
  MyIocContainer._()

  /// Override other methods and add custom implementation.
  ...
}
```

The [flutter_ioc_get_it](../flutter_ioc_get_it/) package can be used as a 
reference on how to add a completely custom implementation of the 
`IocContainer` class.

**Important:** if you are building a library that internally uses inversion of
control make sure to directly depend on the `flutter_ioc` package and not one
of the specific implementations. This will avoid tightly coupling and allows 
you to easily replace specific implementations at a later time (or during 
testing).

## Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

## Issues

Please file any issues, bugs or feature requests as an issue on our 
[GitHub](https://github.com/Baseflow/flutter_ioc/issues) page. Commercial support
is available, you can contact us at <hello@baseflow.com>.

## Author

This flutter_ioc package for Flutter is developed by [Baseflow](https://baseflow.com).
