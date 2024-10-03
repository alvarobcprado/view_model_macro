import 'dart:async';

import 'package:view_model_macro/src/models/notifier.dart';

/// {@template ActionNotifier}
/// A [Notifier] that can be used to dispatch actions from ViewModel to View.
///
/// It can't hold any data and only emits actions.
///
/// See more:
/// - [Notifier]: The base class for Notifiers.
/// - [StateNotifier]: The notifier that holds states.
/// {@endtemplate}
class ActionNotifier<T> extends Notifier<T> {
  /// {@macro ActionNotifier}
  ActionNotifier() : _controller = StreamController<T>.broadcast();

  final StreamController<T> _controller;

  @override
  void notify(T value) {
    _controller.add(value);
  }

  @override
  Stream<T> get stream => _controller.stream;

  ActionStream<T> asActionStream() => ActionStream<T>(stream);

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }
}

extension type ActionStream<T>(Stream<T> stream) {}
