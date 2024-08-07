import 'dart:async';

/// Describes the type of change that occurred which triggered the
/// [IocContainer.OnScopeChanged] callback.
enum ScopeChange {
  /// Indicates a new scope was created and is now active.
  created,

  /// Indicates a scope was removed and its parent scope is now active.
  removed,
}

/// A shorter alias for the [IocContainer] type. This allows developers to
/// use the shorter `Ioc.container` syntax instead of writing the full name.
typedef Ioc = IocContainer;

/// A standard interface providing inversion of control services to Dart or
/// Flutter applications.
abstract class IocContainer {
  static late IocContainer _container;

  /// Gets the registered [IocContainer] instance.
  ///
  /// Before accessing the [container] make sure an specific implementation is
  /// registered using the [registerContainer] method. Failing to do so will
  /// result in a [LateInitializationError].
  static IocContainer get container => _container;

  /// Allows registering a custom implementation of the [IocContainer] interface.
  ///
  /// The [iocContainer] parameter must be a concrete implementation of the
  /// [IocContainer] interface. This implementation will then be used as the
  /// global IoC container instance.
  static void registerContainer(IocContainer iocContainer) =>
      _container = iocContainer;

  /// Gets the name of the current scope.
  ///
  /// If the current scope doesn't have a name `null` if returned. If the
  /// current scope is the root scope 'root' is returned.
  String? get currentScope;

  /// The callback that is called when the current scope has changed.
  ///
  /// Detecting scope changes can be helpful in situations where depending code
  /// needs to updates its dependencies based on the registration in the new
  /// scope.
  ///
  /// The [scopeChange] parameter supplied to the callback indicates if a new
  /// scope was added (see [createScope]) or an existing scope was removed (
  /// see [removeScope]).
  void Function(ScopeChange scopeChange)? onScopeChanged;

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

  /// Gets an instance matching the specified type [T] asynchronously.
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
  /// // Register an asynchronous factory method to create a new instance of
  /// // the Counter class starting at 0.
  /// IocContainer.container.registerFactoryAsync<Counter>(() async => Counter(), instanceName: 'zero_based_counter');
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = await IocContainer.container.getAsync<Counter>(instanceName: 'zero_based_counter');
  /// ```
  Future<T> getAsync<T extends Object>({
    String? instanceName,
  });

  /// Gets all instances matching the specified type [T].
  ///
  /// ```dart
  /// class Service {}
  ///
  /// // Register multiple instances of the Service class.
  /// IocContainer.container.registerFactory<Service>(() => Service(), instanceName: 'service1');
  /// IocContainer.container.registerFactory<Service>(() => Service(), instanceName: 'service2');
  ///
  /// // Get all Service instances from the IocContainer.
  /// final services = IocContainer.container.getAll<Service>();
  /// ```
  Iterable<T> getAll<T extends Object>();

  /// Gets all instances matching the specified type [T] asynchronously.
  ///
  /// ```dart
  /// class Service {}
  ///
  /// // Register multiple instances of the Service class.
  /// IocContainer.container.registerFactoryAsync<Service>(() async => Service(), instanceName: 'service1');
  /// IocContainer.container.registerFactoryAsync<Service>(() async => Service(), instanceName: 'service2');
  ///
  /// // Get all Service instances from the IocContainer.
  /// final services = await IocContainer.container.getAllAsync<Service>();
  /// ```
  Future<Iterable<T>> getAllAsync<T extends Object>();

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
  ///
  /// When set to `true` the [allowReassignment] parameter allows developers to
  /// replace an existing registration with the one supplied. By default this
  /// value is `false` as it would normally not be required and in most cases is
  /// a bug. However in some special cases this might be valuable and allows
  /// developers to override an earlier registered factory.
  void registerFactory<T extends Object>(
    T Function() factoryFunction, {
    String? instanceName,
    bool allowReassignment = false,
  });

  /// Registers an asynchronous factory method creating a new instance of the specified type [T].
  ///
  /// The registered factory method is called each time the [IocContainer.getAsync]
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
  /// // Register an asynchronous factory method to create a new instance of the Counter
  /// // class each time `IocContainer.container.getAsync<Counter>()` is called.
  /// IocContainer.container.registerFactoryAsync<Counter>(() async => Counter());
  ///
  /// // Get a new Counter instance from the IocContainer
  /// final Counter counter = await IocContainer.container.getAsync<Counter>();
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
  /// // Register an asynchronous factory method to create a new instance of the Counter
  /// // class starting at 0.
  /// IocContainer.container.registerFactoryAsync<Counter>(() async => Counter(), instanceName: 'zero_based_counter');
  /// // Register an asynchronous factory method to create a new instance of the Counter
  /// // class starting at 1.
  /// IocContainer.container.registerFactoryAsync<Counter>(() async => Counter(count: 1), instanceName: 'one_based_counter');
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = await IocContainer.container.getAsync<Counter>(instanceName: 'zero_based_counter');
  /// // Get a new one-based Counter instance from the IocContainer.
  /// final Counter oneBasedCounter = await IocContainer.container.getAsync<Counter>(instanceName: 'one_based_counter');
  /// ```
  ///
  /// When set to `true` the [allowReassignment] parameter allows developers to
  /// replace an existing registration with the one supplied. By default this
  /// value is `false` as it would normally not be required and in most cases is
  /// a bug. However in some special cases this might be valuable and allows
  /// developers to override an earlier registered factory.
  void registerFactoryAsync<T extends Object>(
    Future<T> Function() factoryFunc, {
    String? instanceName,
    bool allowReassignment = false,
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
  /// When set to `true` the [allowReassignment] parameter allows developers to
  /// replace an existing registration with the one supplied. By default this
  /// value is `false` as it would normally not be required and in most cases is
  /// a bug. However in some special cases this might be valuable and allows
  /// developers to override an earlier registered singleton.
  ///
  /// The [onDispose] callback is called when the lazy singleton is destroyed
  /// (for example when the [reset], [resetLazySingleton] or [remove] methods
  /// are called) and can be used to clean up additional resources.
  void registerLazySingleton<T extends Object>(
    T Function() factoryFunction, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
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
  /// IocContainer.container.registerSingleton<Counter>(Counter(), instanceName: 'zero_based_counter');
  /// // Register a new instance of the Counter class, starting at 42.
  /// IocContainer.container.registerSingleton<Counter>(Counter(count: 42), instanceName: 'fortytwo_based_counter');
  ///
  /// // Get the zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get the fortytwo-based Counter instance from the IocContainer.
  /// final Counter fortyTwoBasedCounter = IocContainer.container.get<Counter>(instanceName: 'fortytwo_based_counter');
  /// ```
  ///
  /// When set to `true` the [allowReassignment] parameter allows developers to
  /// replace an existing registration with the one supplied. By default this
  /// value is `false` as it would normally not be required and in most cases is
  /// a bug. However in some special cases this might be valuable and allows
  /// developers to override an earlier registered singleton.
  ///
  /// The [onDispose] callback is called when the singleton is destroyed
  /// (for example when the [reset] or [remove] methods are called) and
  /// can be used to clean up additional resources.
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  });

  /// Resets an earlier created instance of a registered lazy singleton.
  ///
  /// Resetting the singleton will cause the IoC container to call the
  /// registered factory function again the next time the [get] method is
  /// invoked. This will recreate a new singleton.
  ///
  /// Selecting the lazy singleton to reset can be done by providing the
  /// [instance] to reset, providing the registered type [T] or the
  /// [instanceName] the lazy singleton was registered with.
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
  ///
  /// // Get a new zero-based Counter instance from the IocContainer.
  /// Counter counter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  ///
  /// // Increase the current count.
  /// counter.increment();
  /// // The current count should by increased to 1.
  /// print('Current count: ${counter.count}');
  ///
  /// // Reset the lazy singleton
  /// IocContainer.container.resetLazySingleton<Counter>();
  ///
  /// // Get the Counter instance from the IocContainer.
  /// counter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  ///
  /// // Increment the current count.
  /// counter.increment();
  /// // The current count should be incremented to 1 as a new instance was created.
  /// print('Current count: ${counter.count}');
  /// ```
  ///
  /// If resources need to be disposed before the reset, provide a
  /// [onDispose] callback. This function overrides the disposing
  /// you might have provided when registering.
  FutureOr<void> resetLazySingleton<T extends Object>({
    T? instance,
    String? instanceName,
    FutureOr<void> Function(T)? onDispose,
  });

  /// Creates a new registration scope.
  ///
  /// Registering types after creating a new scope will hide any previous
  /// registrations of the same type. Scopes will allow for managing different
  /// lifetimes of your objects. Scopes are stacked upon each other, when an
  /// object is retrieved it will look for it in the top-most scope (the one
  /// created last) first. If the object isn't found, it will look into the
  /// next scope. This will continue until the object is found or until there
  /// are no more scopes (which will result in an error).
  ///
  /// The optional [scopeName] parameter can be used to provide a name for the
  /// scope.
  ///
  /// The [onDispose] callback is called when the scope is disposed and can be
  /// used to clean up additional resources.
  void createScope({
    String? scopeName,
    FutureOr<void> Function()? onDispose,
  });

  /// Removes the current scope from the [IocContainer].
  ///
  /// Removing the current scope will dispose all factories and singletons
  /// registered within the scope and makes the parent scope active again.
  ///
  /// Provided dispose callbacks on factories and singletons will be called
  /// when removing the scope. If a dispose callback was supplied when
  /// creating the scope it will also be called.
  ///
  /// ```dart
  /// // Create a new scope.
  /// IocContainer.container.createScope(scopeName: 'child_scope');
  ///
  /// // Register a factory method to create a new instance of the Counter
  /// // class in the child scope.
  /// IocContainer.container.registerFactory<Counter>(() => Counter());
  ///
  /// // Get a new Counter instance from the IocContainer.
  /// final Counter counter = IocContainer.container.get<Counter>();
  ///
  /// // Remove the current scope (child_scope).
  /// IocContainer.container.removeScope();
  /// ```
  Future<void> removeScope();

  /// Checks if a scope with the specified name exists.
  ///
  /// This method returns `true` if a scope with the provided [scopeName] exists
  /// in the current container's scope hierarchy, and `false` otherwise.
  ///
  /// The [scopeName] parameter specifies the name of the scope to check for.
  ///
  /// ```dart
  /// // Create a new scope with a specific name.
  /// IocContainer.container.createScope(scopeName: 'myScope');
  ///
  /// // Check if the 'myScope' exists.
  /// final bool scopeExists = IocContainer.container.hasScope('myScope');
  /// print(scopeExists); // Prints "true".
  ///
  /// // Check if a non-existent scope exists.
  /// final bool nonExistentScope = IocContainer.container.hasScope('nonExistent');
  /// print(nonExistentScope); // Prints "false".
  /// ```
  ///
  /// Returns:
  /// - `true` if the scope exists.
  /// - `false` if the scope does not exist.
  bool hasScope(String scopeName);
}
