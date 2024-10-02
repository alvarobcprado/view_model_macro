import 'dart:async';

import 'package:view_model_macro/src/models/disposable.dart';

/// {@template Notifier}
/// A base class for [Notifier]s.
///
/// It notifies its listeners when it emits a new value with the [notify] method
/// and can be listened with the [listen] method.
///
/// Also, it can be disposed with the [dispose] method.
///
/// See more:
/// - [StateNotifier]: A notifier that holds states.
/// - [ActionNotifier]: A notifier to dispatch actions.
/// {@endtemplate}
abstract class Notifier<T> implements Disposable {
  final List<StreamSubscription<T>> _subscriptions = [];

  /// The stream that yields a new value when it is notified.
  Stream<T> get stream;

  /// Notifies all listeners with the new value.
  void notify(T value);

  /// Listens to the stream and calls [onData] when the data changes.
  StreamSubscription<T> listen(void Function(T) onData) {
    final subscription = stream.listen(onData);
    _subscriptions.add(subscription);

    return subscription;
  }

  /// Disposes all subscriptions
  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
