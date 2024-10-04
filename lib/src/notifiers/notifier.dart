import 'dart:async';

import 'package:meta/meta.dart';

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
abstract class Notifier<T> {
  /// {@macro Notifier}
  Notifier();

  final StreamController<T> _controller = StreamController<T>.broadcast();
  final List<StreamSubscription<T>> _subscriptions = [];

  /// Notifies all listeners with the new value.
  @mustCallSuper
  void notify(T value) => _controller.add(value);


  /// Returns the stream of the notifier
  @protected
  Stream<T> get stream => _controller.stream;

  /// Listens to the stream and calls [onData] when the data changes.
  StreamSubscription<T> listen(void Function(T) onData) {
    final subscription = _controller.stream.listen(onData);
    _subscriptions.add(subscription);

    return subscription;
  }

  /// Disposes all subscriptions
  @mustCallSuper
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _controller.close();
  }
}
