import 'dart:async';

import 'package:flutter/material.dart';

abstract class Notifier<T> {
  final List<StreamSubscription<T>> _subscriptions = [];
  Stream<T> get stream;

  void emit(T value);

  StreamSubscription<T> listen(void Function(T) onData) {
    final subscription = stream.listen(onData);
    _subscriptions.add(subscription);

    return subscription;
  }

  @mustCallSuper
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
