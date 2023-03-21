An implementation of the flutter_ioc package using the popular 
[GetIt](https://pub.dev/packages/get_it) service locator as backing IoC 
container.

## Features

The following features are supported:

- Register factory methods to return a new instance everytime one is requested.
- Register lazy singletons which are constructed the first time they are 
requested but reuse the instance for subsequent requests.
- Register an instance as singleton.
- Use scopes to manage different lifetimes.

> **Important:** if you are integrating flutter_ioc in a Dart or Flutter 
library please make sure to only depend on the `flutter_ioc` package. 

## Getting started

To start using the `flutter_ioc_get_it` package add it as a dependency in 
the `pubspec.yaml` file running the following command:

With Dart:
```
dart pub add flutter_ioc_get_it
```

With Flutter:
```
flutter pub add flutter_ioc_get_it
```

## Usage

First make sure to import the `flutter_ioc_get_it` library:

```dart
import 'package:flutter_ioc_get_it/flutter_ioc_get_it.dart';
```

### Register specific implementation

Once the library is imported, the `GetItContainer` should be registered as the
implementation to use with the `IocContainer` library. 

> **Important:** the registration step is not necessary when developing a Dart
> or Flutter library. It would be the responsibility of the consuming application
> to handle the registration. This will prevent tightly coupling in your library.
>
> Note that it is good practice to explain the dependency in the documentation 
> of your library and inform other developers they need to register a specific
> implementation of the `flutter_ioc` interface.

It is important that the registration is done **before** the first time the
`IocContainer.container` instance is accessed. To be sure this is done before 
the `IocContainer.container` field is accessed, call the 
`GetItContainer.register()` method as one of the first lines in your `main`
function:

```dart
void main() {
  // Register the `GetItIocContainer` as the inversion of control 
  // implementation to be used.
  GetItIocContainer.register();

  /// Continue with the rest of your application code.
  ...
}
```

### Using the IocContainer library

Now the `flutter_ioc` library can be accessed through the 
`IocContainer.container` field. Below are some examples showing the diffent 
ways objects can be registered and retrieved with the inversion of control 
container.

The samples shown below will be referencing a very simple `Counter` class 
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

> For a working example of the snippets below, checkout the [example](example/flutter_ioc_example.dart)
> demo application.

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
