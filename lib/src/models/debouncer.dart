import 'dart:async';

import 'package:view_model_macro/src/models/disposable.dart';

/// {@template Debouncer}
/// A [Disposable] that can be used to debounce a method call.
/// {@endtemplate}
class Debouncer implements Disposable {
  /// {@macro Debouncer}
  Debouncer(this.milliseconds);

  /// The time in milliseconds to debounce the method call.
  final int milliseconds;
  Timer? _timer;

  /// Runs the [action] debouncing the method call for [milliseconds].
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
