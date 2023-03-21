import 'package:flutter_ioc_get_it/flutter_ioc_get_it.dart';

/// Keeps track of the count.
class Counter {
  /// Creates a [Counter].
  Counter({this.count = 0});

  /// The current count.
  int count;

  /// Increments the [count] by one.
  void increment() => count++;
}

/// The name used to register a zero based counter instance.
const String kZeroBaseCounterName = 'zero_based_counter';

/// The name used to register a forty two based counter instance.
const String kFortyTwoBaseCounterName = 'fortytwo_based_counter';

void main() {
  // Register the [GetItIocContainer] as implementation to use.
  GetItIocContainer.register();

  _exampleUsingRegisterFactory();
  _exampleUsingRegisterLazySingleton();
  _exampleUsingRegisterSingleton();
}

void _exampleUsingRegisterFactory() {
  // Register a factory method to create a new instance of the Counter
  // class each time `IocContainer.container.get<Counter>()` is called.
  IocContainer.container.registerFactory<Counter>(() => Counter());
  // Register a factory method to create a new instance of the Counter
  // class starting at 0.
  IocContainer.container.registerFactory<Counter>(() => Counter(),
      instanceName: kZeroBaseCounterName);
  // Register a factory method to create a new instance of the Counter
  // class starting at 42.
  IocContainer.container.registerFactory<Counter>(() => Counter(count: 42),
      instanceName: kFortyTwoBaseCounterName);

  _interactWithCounters();
}

void _exampleUsingRegisterLazySingleton() {
  // Create a new scope, so we can change the lifetime configuration of our
  // [Counter] instance.
  IocContainer.container.createScope(scopeName: 'Lazy Singleton');

  // Register a factory method to create a new instance of the Counter
  // class the first time `IocContainer.container.get<Counter>()` is called.
  IocContainer.container.registerLazySingleton<Counter>(() => Counter());
  // Register a factory method to create a new instance of the Counter
  // class starting at 0.
  IocContainer.container.registerLazySingleton<Counter>(() => Counter(),
      instanceName: kZeroBaseCounterName);
  // Register a factory method to create a new instance of the Counter
  // class starting at 42.
  IocContainer.container.registerLazySingleton<Counter>(
      () => Counter(count: 42),
      instanceName: kFortyTwoBaseCounterName);

  _interactWithCounters();
}

void _exampleUsingRegisterSingleton() {
  // Create a new scope, so we can change the lifetime configuration of our
  // [Counter] instance.
  IocContainer.container.createScope(scopeName: 'Singleton');

  // Register an instance of the Counter class which is returned when
  // the `IocContainer.container.get<Counter>()` method is called.
  IocContainer.container.registerSingleton<Counter>(Counter());
  // Register an instance of the Counter class starting at 0.
  IocContainer.container.registerSingleton<Counter>(Counter(),
      instanceName: kZeroBaseCounterName);
  // Register an instance of the Counter class starting at 42.
  IocContainer.container.registerSingleton<Counter>(Counter(count: 42),
      instanceName: kFortyTwoBaseCounterName);

  _interactWithCounters();
}

void _interactWithCounters() {
  final Counter counter = IocContainer.container.get<Counter>();
  final Counter zeroBasedCounter =
      IocContainer.container.get<Counter>(instanceName: kZeroBaseCounterName);
  final Counter fortyTwoBasedCounter = IocContainer.container
      .get<Counter>(instanceName: kFortyTwoBaseCounterName);

  counter.increment();
  zeroBasedCounter.increment();
  fortyTwoBasedCounter.increment();

  print('Scope: ${IocContainer.container.currentScope}');
  print('  - Counter: ${counter.count}');
  print('  - Zero-based counter: ${zeroBasedCounter.count}');
  print('  - Forty two-based counter: ${fortyTwoBasedCounter.count}');
  print('\n');
}
