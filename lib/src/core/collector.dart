import 'dart:async';

import 'package:flutter/material.dart';
import 'package:view_model_macro/src/widgets/stream_listener.dart';

/// Extension methods for collecting data from [Stream]s.
extension StreamCollectorX<T> on Stream<T> {
  /// Collects the data from the stream to build a widget based on its data.
  Widget collectAsWidget(
    Widget Function(T) builder, {
    Widget? emptyData,
    T? initialData,
  }) {
    return StreamBuilder(
      stream: this,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data as T);
        } else {
          return emptyData ?? const SizedBox.shrink();
        }
      },
    );
  }

  /// Collects the data from the stream and listens to it by calling [onData]
  /// when the data changes inside the Widget tree.
  Widget collectAsListener({required void Function(T) onData, Widget? child}) {
    return StreamListener(
      stream: this,
      onData: onData,
      child: child,
    );
  }

  /// Collects the data from the stream and listens to it by calling [onData]
  /// when the data changes outside the Widget tree.
  StreamSubscription<T> collect(void Function(T) onData) =>
      listen((data) => onData(data));
}
