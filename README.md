A standard interface providing inversion of control services to 
Dart or Flutter applications.

## Features

The following features are supported:

- Register factory methods to return a new instance everytime one is requested.
- Register lazy singletons which are constructed the first time they are 
requested but reuse the instance for subsequent requests.
- Register an instance as singleton.

All registration methods optionally support supplying a name, making it
possible to register multiple instances of the same type using a different name.

By default the `flutter_ioc` package is configured to use [get_it](https://pub.dev/packages/get_it) 
as backing inversion of control solution. This can however be easily overriden
using the static `IocContainer.registerContainer` method and supplying a custom
implementation of the `IocContainer` interface.

## Getting started

To start using the `flutter_ioc` package add it as a dependency in the `pubspec.yaml`
file running the following command:

With Dart:
```
dart pub add flutter_ioc
```

With Flutter:
```
flutter pub add flutter_ioc
```

## Usage

First make sure to import the `flutter_ioc` library:

```dart
import 'package:flutter_ioc/flutter_ioc.dart';
```

Once the library is imported the `flutter_ioc` library can be accessed through
the `IocContainer.container` field. Below are some examples showing the diffent
ways objects can be registered and retrieved with the inversion of control 
container.

### Examples

All the samples shown below will be referencing a very simple `Counter` class 
that is used to demostrate the different ways to register and retrieve objects
to and from the `IocContainer.container`. Although the implementation of this
class in not relevant at all it could look something like this:

```dart
class Counter {
    Counter({this.count = 0});

    int count;

    void increment() => count++;
}
```

To register the `Counter` class with the `IocContainer.container` and have it 
return a new instance each time one is requested, use the `registerFactory` method:

```dart
// Register a factory method to create a new instance of Counter.
IocContainer.container.registerFactory<Counter>(() => Counter());

// Retrieve a new instance of Counter.
final Counter counter = IocContainer.container.get<Counter>();
```

To register multiple versions of the same type specify a name:

```dart
// Register a factory method to create a new instance of Counter
// starting at 0.
IocContainer.container.registerFactory<Counter>(
    () => Counter(),
    instanceName: 'zero-based-counter');
// Register a factory method to create a new instance of Counter
// starting at 42.
IocContainer.container.registerFactory<Counter>(
    () => Counter(count: 42),
    instanceName: '42-based-counter');

// Retrieve a new instance of the Counter starting at 0.
final Counter zeroCounter = IocContainer.container.get<Counter>(instanceName: 'zero-based-counter');
// Retrieve a new instance of the Counter starting at 42.
final Counter forthyTwoCounter = IocContainer.container.get<Counter>(instanceName: '42-based-counter');
```

To register the `Counter` class as a singleton that is only created once it is
accessed for the first time use the `registerLazySingleton` method:

```dart
// Register a factory method to create singleton instance of Counter.
IocContainer.container.registerLazySingleton<Counter>(() => Counter());

// Retrieve the singleton instance of Counter.
final Counter counter = IocContainer.container.get<Counter>();
```

To register multiple versions of the same type as lazily initialized 
singleton, specify a name:

```dart
// Register a factory method to create a singleton of Counter
// starting at 0.
IocContainer.container.registerLazySingleton<Counter>(
    () => Counter(),
    instanceName: 'zero-based-counter');
// Register a factory method to create a singleton of Counter
// starting at 42.
IocContainer.container.registerLazySingleton<Counter>(
    () => Counter(count: 42),
    instanceName: '42-based-counter');

// Retrieve the singleton instance of the Counter starting at 0.
final Counter zeroCounter = IocContainer.container.get<Counter>(instanceName: 'zero-based-counter');
// Retrieve the singleton instance of the Counter starting at 42.
final Counter forthyTwoCounter = IocContainer.container.get<Counter>(instanceName: '42-based-counter');
```

To register the `Counter` class as a singleton that is already initialized use 
the `registerSingleton` method:

```dart
// Register an instance of Counter that will be treated as singleton.
IocContainer.container.registerSingleton<Counter>(Counter());

// Retrieve the singleton instance of Counter.
final Counter counter = IocContainer.container.get<Counter>();
```

To register multiple singleton versions of the same type:

```dart
// Register an instance of Counter starting at 0.
IocContainer.container.registerSingleton<Counter>(
    Counter(),
    instanceName: 'zero-based-counter');
// Register an instance of Counter starting at 42.
IocContainer.container.registerSingleton<Counter>(
    Counter(count: 42),
    instanceName: '42-based-counter');

// Retrieve the singleton instance of the Counter starting at 0.
final Counter zeroCounter = IocContainer.container.get<Counter>(instanceName: 'zero-based-counter');
// Retrieve the singleton instance of the Counter starting at 42.
final Counter forthyTwoCounter = IocContainer.container.get<Counter>(instanceName: '42-based-counter');
```
