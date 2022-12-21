import 'package:flutter_ioc/flutter_ioc.dart';

/// Keeps track of the count.
class Counter {
  Counter({this.count = 0});

  /// The current count.
  int count;

  /// Increments the [count] by one.
  void increment() => count++;
}

const String kZeroBaseCounterName = 'zero_based_counter';
const String kForthyTwoBaseCounterName = 'forthytwo_based_counter';

void main() {
  registerUsingRegisterFactory();
  // registerUsingRegisterLazySingleton();
  // registerUsingRegisterSingleton();

  final Counter counter = IocContainer.container.get<Counter>();
  final Counter zeroBasedCounter =
      IocContainer.container.get<Counter>(instanceName: kZeroBaseCounterName);
  final Counter forthyTwoBasedCounter = IocContainer.container
      .get<Counter>(instanceName: kForthyTwoBaseCounterName);

  counter.increment();
  print('Counter: ${counter.count}');
  zeroBasedCounter.increment();
  print('Zero-based counter: ${zeroBasedCounter.count}');
  forthyTwoBasedCounter.increment();
  print('Forthy two-based counter: ${forthyTwoBasedCounter.count}');
}

void registerUsingRegisterFactory() {
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
      instanceName: kForthyTwoBaseCounterName);
}

void registerUsingRegisterLazySingleton() {
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
      instanceName: kForthyTwoBaseCounterName);
}

void registerUsingRegisterSingleton() {
  // Register an instance of the Counter class which is returned when
  // the `IocContainer.container.get<Counter>()` method is called.
  IocContainer.container.registerSingleton<Counter>(Counter());
  // Register an instance of the Counter class starting at 0.
  IocContainer.container.registerSingleton<Counter>(Counter(),
      instanceName: kZeroBaseCounterName);
  // Register an instance of the Counter class starting at 42.
  IocContainer.container.registerSingleton<Counter>(Counter(count: 42),
      instanceName: kForthyTwoBaseCounterName);
}
