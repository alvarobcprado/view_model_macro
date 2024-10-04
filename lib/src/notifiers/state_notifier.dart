import 'dart:async';

import 'package:view_model_macro/src/notifiers/notifier.dart';

/// The type wrapper for [Stream]s emitted by a [StateNotifier].
extension type StateStream<T>(Stream<T> stream) {}

/// {@template StateNotifier}
/// A [Notifier] that holds a state of type [T].
///
/// It notifies its listeners when it emits a new value with the [notify] method
/// and can be listened with the [listen] method.
///
/// Also, the current state can be accessed with the [state] getter.
///
/// See more:
/// - [Notifier]: The base class for Notifiers.
/// - [ActionNotifier]: A notifier to dispatch actions.
/// {@endtemplate}
class StateNotifier<T> extends Notifier<T> {
  /// {@macro StateNotifier}
  StateNotifier(this._state);

  T _state;

  /// The current state value.
  T get state => _state;

  @override
  void notify(T value) {
    _state = value;
    super.notify(value);
  }

  /// Returns a stream of states emitted by the [StateNotifier].
  StateStream<T> get stateStream => StateStream<T>(stream);
}
