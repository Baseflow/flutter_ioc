import 'dart:async';

import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:get_it/get_it.dart';

/// An implementation of the [IocContainer] interface using get_it as
/// backing inversion of control container.
///
/// For more information on get_it, see: https://pub.dev/packages/get_it.
class GetItIocContainer extends IocContainer {
  /// Registers the get_it specific implementation as container to use with the
  /// [IocContainer] library.
  static void register() {
    IocContainer.registerContainer(GetItIocContainer._());
  }

  GetItIocContainer._();

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
    T Function() factoryFunction, {
    String? instanceName,
    bool allowReassignment = false,
  }) =>
      _guardedReassignment(
        () => _container.registerFactory<T>(factoryFunction,
            instanceName: instanceName),
        allowReassignment,
      );

  @override
  void registerLazySingleton<T extends Object>(
    T Function() factoryFunction, {
    String? instanceName,
    bool allowReassignment = false,
    FutureOr<void> Function(T)? onDispose,
  }) =>
      _guardedReassignment(
        () => _container.registerLazySingleton<T>(
          factoryFunction,
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
  set onScopeChanged(
      void Function(ScopeChange scopeChange)? onScopeChangedCallback) {
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
