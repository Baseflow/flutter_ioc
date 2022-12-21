import 'package:get_it/get_it.dart';

/// A standard interface providing inversion of control services to Dart or
/// Flutter applications.
///
/// The default implementation uses [get_it](https://pub.dev/packages/get_it) as
/// inversion of control solution. To override the default container use the
/// [IocContainer.registerContainer] method.
abstract class IocContainer {
  static IocContainer? _container;

  /// Gets the registered [IocContainer] instance.
  ///
  /// The default implementation uses [get_it](https://pub.dev/packages/get_it) as
  /// inversion of control solution. To override the default container use the
  /// [IocContainer.registerContainer] method.
  static IocContainer get container => _container ?? _GetItIocContainer._();

  /// Allows registering a custom implementation of the [IocContainer] interface.
  static void registerContainer(IocContainer iocContainer) =>
      _container = iocContainer;

  /// Gets an instance matching the specified type [T].
  ///
  /// Use the [instanceName] parameter to fetch a specific instance that was
  /// registered with the same name and type.
  ///
  /// ```dart
  /// class Counter {
  ///   Counter({this.count = 0});
  ///
  ///   int count;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 0.
  /// IocContainer.container.registerFactory<Counter>(() => Counter(), instanceName: 'zero_based_counter');
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 1.
  /// IocContainer.container.registerFactory<Counter>(() => Counter(count: 1), instanceName: 'one_based_counter');
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get a new one-based Counter instance from the IocContainer.
  /// final Counter oneBasedCounter = IocContainer.container.get<Counter>(instanceName: 'one_based_counter');
  /// ```
  T get<T extends Object>({
    String? instanceName,
  });

  /// Registers a factory method creating a new instance of the specified type [T].
  ///
  /// The registered factory method is called each time the [IocContainer.get]
  /// method is called.
  ///
  /// ```dart
  /// class Counter {
  ///   int count = 0;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class each time `IocContainer.container.get<Counter>()` is called.
  /// IocContainer.container.registerFactory<Counter>(() => Counter());
  ///
  /// // Get a new Counter instance from the IocContainer
  /// final Counter counter = IocContainer.container.get<Counter>();
  /// ```
  ///
  /// Use the [instanceName] parameter to specify different factory methods
  /// for the specified type:
  ///
  /// ```dart
  /// class Counter {
  ///   Counter({this.count = 0});
  ///
  ///   int count;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 0.
  /// IocContainer.container.registerFactory<Counter>(() => Counter(), instanceName: 'zero_based_counter');
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 1.
  /// IocContainer.container.registerFactory<Counter>(() => Counter(count: 1), instanceName: 'one_based_counter');
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get a new one-based Counter instance from the IocContainer.
  /// final Counter oneBasedCounter = IocContainer.container.get<Counter>(instanceName: 'one_based_counter');
  /// ```
  void registerFactory<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
  });

  /// Registers a factory method creating a new instance of the specified type [T].
  ///
  /// The registered factory method is called the first time the [IocContainer.get]
  /// method is called. Subsequent calls to [IocContainer.get] will return the
  /// instance that was created the first time the [IocContainer.get] method was
  /// called.
  ///
  /// ```dart
  /// class Counter {
  ///   int count = 0;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class the first time `IocContainer.container.get<Counter>()` is called.
  /// IocContainer.container.registerLazySingleton<Counter>(() => Counter());
  ///
  /// // Get a new Counter instance from the IocContainer
  /// final Counter firstCounter = IocContainer.container.get<Counter>();
  /// // Get the existing Counter instance from the IocContainer
  /// final Counter secondCounter = IocContainer.container.get<Counter>();
  /// print(identical(firstCounter, secondCounter)); // Prints "true".
  /// ```
  ///
  /// Use the [instanceName] parameter to specify different factory methods
  /// for the specified type:
  ///
  /// ```dart
  /// class Counter {
  ///   Counter({this.count = 0});
  ///
  ///   int count;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 0.
  /// IocContainer.container.registerLazySingleton<Counter>(() => Counter(), instanceName: 'zero_based_counter');
  /// // Register a factory method to create a new instance of the Counter
  /// // class starting at 10.
  /// IocContainer.container.registerLazySingleton<Counter>(() => Counter(count: 10), instanceName: 'ten_based_counter');
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get a new ten-based Counter instance from the IocContainer.
  /// final Counter tenBasedCounter = IocContainer.container.get<Counter>(instanceName: 'ten_based_counter');
  /// ```
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
  });

  /// Registers a specific instance of type [T].
  ///
  /// The registered instance will be returned each time the [IocContainer.get]
  /// method is called.
  ///
  /// ```dart
  /// class Counter {
  ///   int count = 0;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a new instance of the Counter class that will be returned
  /// // each time `IocContainer.container.get<Counter>()` is called.
  /// IocContainer.container.registerSingleton<Counter>(Counter());
  ///
  /// // Get the Counter instance from the IocContainer.
  /// final Counter counter = IocContainer.container.get<Counter>();
  /// ```
  ///
  /// Use the [instanceName] parameter to specify different factory methods
  /// for the specified type:
  ///
  /// ```dart
  /// class Counter {
  ///   Counter({this.count = 0});
  ///
  ///   int count;
  ///
  ///   void increment() => count++;
  ///   void decrement() => count--;
  /// }
  ///
  /// // Register a new instance of the Counter class, starting at 0.
  /// IocContainer.container.registerLazySingleton<Counter>(Counter(), 'zero_based_counter');
  /// // Register a new instance of the Counter class, starting at 42.
  /// IocContainer.container.registerLazySingleton<Counter>(Counter(count: 42), 'forthytwo_based_counter');
  ///
  /// // Get the zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get the forthytwo-based Counter instance from the IocContainer.
  /// final Counter forthyTwoBasedCounter = IocContainer.container.get<Counter>(instanceName: 'forthytwo_based_counter');
  /// ```
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  });
}

/// An implementation of the [IocContainer] interface using get_it as
/// backing inversion of control container.
///
/// For more information on get_it, see: https://pub.dev/packages/get_it.
class _GetItIocContainer implements IocContainer {
  _GetItIocContainer._();

  final GetIt _container = GetIt.instance;

  @override
  T get<T extends Object>({
    String? instanceName,
  }) =>
      _container.get<T>(instanceName: instanceName);

  @override
  void registerFactory<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
  }) =>
      _container.registerFactory<T>(func, instanceName: instanceName);

  @override
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
  }) =>
      _container.registerLazySingleton<T>(func, instanceName: instanceName);

  @override
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  }) =>
      _container.registerSingleton<T>(instance, instanceName: instanceName);
}
