import 'dart:async';

import 'package:get_it/get_it.dart';

/// Describes the type of change that occurred which triggered the
/// [IocContainer.OnScopeChanged] callback.
enum ScopeChange {
  /// Indicates a new scope was created and is now active.
  created,

  /// Indicates a scope was removed and its parent scope is now active.
  removed,
}

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
  /// IocContainer.container.registerLazySingleton<Counter>(Counter(), 'zero_based_counter');
  /// // Register a new instance of the Counter class, starting at 42.
  /// IocContainer.container.registerLazySingleton<Counter>(Counter(count: 42), 'forthytwo_based_counter');
  ///
  /// // Get the zero-based Counter instance from the IocContainer.
  /// final Counter zeroBasedCounter = IocContainer.container.get<Counter>(instanceName: 'zero_based_counter');
  /// // Get the forthytwo-based Counter instance from the IocContainer.
  /// final Counter forthyTwoBasedCounter = IocContainer.container.get<Counter>(instanceName: 'forthytwo_based_counter');
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
  /// // Increatee the current count.
  /// counter.increment();
  /// // The current count should be incremented to 1 as a new instance was created.
  /// print('Current count: ${counter.count}');
  /// ```
  ///
  /// If resources need to be disposed before the reset, provide a
  /// [onDispose] callback. This function overrides the disposing
  /// you might have provided when registering.
  FutureOr<void> resetLazySingleton<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr<void> Function(T)? onDispose,
  });

  /// Creates a new registation scope.
  ///
  /// Registering types after creating a new scope will hide any previous
  /// registrations of the same type. Scopes will allow for managing different
  /// live times of your Objecs. Scopes are stacked upon eachother, when an
  /// Object is retrieved it will look for it in the top most scope (the one
  /// created last) first, if the Object insn't located it will look into the
  /// next scope. This will continue untill the Object is found or until there
  /// are no more scopes (which will result in an error).
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
  Future<void> removeScope();
}

/// An implementation of the [IocContainer] interface using get_it as
/// backing inversion of control container.
///
/// For more information on get_it, see: https://pub.dev/packages/get_it.
class _GetItIocContainer implements IocContainer {
  _GetItIocContainer._();

  final GetIt _container = GetIt.instance;

  @override
  String? get currentScope => _container.currentScopeName == 'baseScope'
      ? 'root'
      : _container.currentScopeName;

  @override
  T get<T extends Object>({
    String? instanceName,
  }) =>
      _container.get<T>(instanceName: instanceName);

  @override
  void registerFactory<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
    bool allowReassignment = false,
  }) =>
      _guardedReassignment(
        () => _container.registerFactory<T>(func, instanceName: instanceName),
        allowReassignment,
      );

  @override
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  }) =>
      _guardedReassignment(
        () => _container.registerLazySingleton<T>(
          func,
          instanceName: instanceName,
          dispose: onDispose,
        ),
        allowReassignment,
      );

  @override
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  }) =>
      _guardedReassignment(
        () => _container.registerSingleton<T>(
          instance,
          instanceName: instanceName,
          dispose: onDispose,
        ),
        allowReassignment,
      );

  @override
  FutureOr<void> resetLazySingleton<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr<void> Function(T)? onDispose,
  }) =>
      _container.resetLazySingleton(
        instance: instance,
        instanceName: instanceName,
        disposingFunction: onDispose,
      );

  @override
  void createScope({
    String? scopeName,
    FutureOr<void> Function()? onDispose,
  }) =>
      _container.pushNewScope(
        scopeName: scopeName,
        dispose: onDispose,
      );

  @override
  Future<void> removeScope() => _container.popScope();

  void _guardedReassignment(
    void Function() register,
    bool allowReassignment,
  ) {
    if (allowReassignment) {
      _container.allowReassignment = true;
    }

    register();

    _container.allowReassignment = false;
  }
  
  void Function(ScopeChange scopeChange)? _onScopeChanged;

  @override
  void Function(ScopeChange scopeChange)? get onScopeChanged => _onScopeChanged;

  @override
  set onScopeChanged(void Function(ScopeChange scopeChange)? onScopeChangedCallback) {
    _onScopeChanged = onScopeChangedCallback;

    _container.onScopeChanged = (bool pushed) {
      void Function(ScopeChange scopeChange)? callback = _onScopeChanged;

      if (callback == null) {
        return;
      }

      callback(pushed ? ScopeChange.created : ScopeChange.removed);
    };
  }
}
