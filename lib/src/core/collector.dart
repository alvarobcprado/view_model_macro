import 'dart:async';

import 'package:flutter/material.dart';
import 'package:view_model_macro/src/models/action_notifier.dart';
import 'package:view_model_macro/src/models/state_notifier.dart';
import 'package:view_model_macro/src/widgets/stream_listener.dart';

/// Extension methods for collecting data from [StateStream]s.
extension StateStreamCollectorX<T> on StateStream<T> {
  /// Collects the data from the stream to build a widget based on its data.
  Widget collectAsWidget(
    Widget Function(T) builder, {
    Widget? emptyData,
    T? initialData,
  }) {
    return StreamBuilder(
      stream: stream,
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
      stream: stream,
      onData: onData,
      child: child,
    );
  }

  /// Collects the data from the stream and listens to it by calling [onData]
  /// when the data changes outside the Widget tree.
  StreamSubscription<T> collect(void Function(T) onData) =>
      stream.listen((data) => onData(data));
}

/// Extension methods for collecting data from [ActionStream]s.
extension ActionStreamCollectorX<T> on ActionStream<T> {
  /// Collects the data from the stream and listens to it by calling [onData]
  /// when the data changes inside the Widget tree.
  Widget collectAsListener({required void Function(T) onData, Widget? child}) {
    return StreamListener(
      stream: stream,
      onData: onData,
      child: child,
    );
  }

  /// Collects the data from the stream and listens to it by calling [onData]
  /// when the data changes outside the Widget tree.
  StreamSubscription<T> collect(void Function(T) onData) =>
      stream.listen((data) => onData(data));
}
