import 'dart:async';

import 'package:flutter/material.dart';
import 'package:view_model_macro/src/widgets/stream_listener.dart';

extension StreamCollectorX<T> on Stream<T> {
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

  Widget collectAsListener({required void Function(T) onData, Widget? child}) {
    return StreamListener(
      stream: this,
      onData: onData,
      child: child,
    );
  }

  StreamSubscription<T> collect(void Function(T) onData) =>
      listen((data) => onData(data));
}
