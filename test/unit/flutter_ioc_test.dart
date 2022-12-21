import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

void main() {
  group('IocContainer', () {
    test('IocContainer.container should return registered container', () {
      final IocContainer container = _MockIocContainer();

      IocContainer.registerContainer(container);

      expect(IocContainer.container, container);
    });

    test(
        'Registered mock implementation of get() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.get(),
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of registerFactory() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.registerFactory<int>(() => 0),
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of registerLazySingleton() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.registerLazySingleton<int>(() => 0),
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of registerSingleton() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.registerSingleton<int>(0),
        throwsUnimplementedError,
      );
    });
  });
}

class _MockIocContainer extends IocContainer {
  @override
  T get<T extends Object>({String? instanceName}) {
    throw UnimplementedError(
        '_MockIocContainer.get has no mock implementation.');
  }

  @override
  void registerFactory<T extends Object>(FactoryFunc<T> func,
      {String? instanceName}) {
    throw UnimplementedError(
        '_MockIocContainer.registerFactory() has no mock implementation.');
  }

  @override
  void registerLazySingleton<T extends Object>(FactoryFunc<T> func,
      {String? instanceName}) {
    throw UnimplementedError(
        '_MockIocContainer.registerLazySingleton() has no mock implementation.');
  }

  @override
  void registerSingleton<T extends Object>(T instance, {String? instanceName}) {
    throw UnimplementedError(
        '_MockIocContainer.registerSingleton() has no mock implementation.');
  }
}
