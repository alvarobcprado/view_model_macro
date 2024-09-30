import 'dart:async';

import 'package:view_model_macro/src/models/notifier.dart';

class StateNotifier<T> extends Notifier<T> {
  StateNotifier(this._state);

  late final StreamController<T> _controller = StreamController<T>.broadcast();

  T _state;
  T get state => _state;

  @override
  void emit(T value) {
    _state = value;
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
