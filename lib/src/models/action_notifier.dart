import 'dart:async';

import 'package:view_model_macro/src/models/notifier.dart';

class ActionNotifier<T> extends Notifier<T> {
  ActionNotifier() : _controller = StreamController<T>.broadcast();

  final StreamController<T> _controller;

  @override
  void emit(T value) {
    _controller.add(value);
  }

  @override
  Stream<T> get stream => _controller.stream;

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }
}
