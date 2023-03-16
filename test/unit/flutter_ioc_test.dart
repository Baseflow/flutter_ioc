import 'dart:async';

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

    test(
        'Registered mock implementation of resetLazySingleton() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.resetLazySingleton<int>(),
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of currentScope getter should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.currentScope,
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of onScopeChanged setter should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.onScopeChanged =
            (ScopeChange scopeChanged) {},
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of createScope() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.createScope(),
        throwsUnimplementedError,
      );
    });

    test(
        'Registered mock implementation of removeScope() should throw unimplemented error',
        () {
      IocContainer.registerContainer(_MockIocContainer());

      expect(
        () => IocContainer.container.removeScope(),
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
  void registerFactory<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
    bool allowReassignment = false,
  }) {
    throw UnimplementedError(
        '_MockIocContainer.registerFactory() has no mock implementation.');
  }

  @override
  void registerLazySingleton<T extends Object>(
    FactoryFunc<T> func, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  }) {
    throw UnimplementedError(
        '_MockIocContainer.registerLazySingleton() has no mock implementation.');
  }

  @override
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  }) {
    throw UnimplementedError(
        '_MockIocContainer.registerSingleton() has no mock implementation.');
  }

  @override
  FutureOr<void> resetLazySingleton<T extends Object>({
    Object? instance,
    String? instanceName,
    FutureOr<void> Function(T)? onDispose,
  }) {
    throw UnimplementedError(
        '_MockIocContainer.resetLazySingleton() has no mock implementation.');
  }

  @override
  String? get currentScope => throw UnimplementedError(
      '_MockIocContainer.currentScope has no mock implementation.');

  @override
  set onScopeChanged(void Function(ScopeChange scopeChange)? onScopeChanged) {
    throw UnimplementedError(
        '_MockIocContainer.onScopeChanged setter has no mock implementation.');
  }

  @override
  void createScope({String? scopeName, FutureOr<void> Function()? onDispose}) {
    throw UnimplementedError(
        '_MockIocContainer.createScope() has no mock implementation.');
  }

  @override
  Future<void> removeScope() {
    throw UnimplementedError(
        '_MockIocContainer.removeScope() has no mock implementation.');
  }
}
