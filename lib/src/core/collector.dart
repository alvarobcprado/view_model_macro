import 'dart:async';

import 'package:flutter/material.dart';
import 'package:view_model_macro/src/models/models_barrel.dart';

extension StateStreamCollectorX<T> on Stream<T> {
  Widget collectAsWidget(Widget Function(T) builder, {Widget? emptyData}) {
    return StreamBuilder(
      stream: this,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data as T);
        } else {
          return emptyData ?? const SizedBox.shrink();
        }
      },
    );
  }

  StreamSubscription<T> collect(void Function(T) onData) =>
      listen((data) => onData(data));
}

extension StateNotifierCollectorX<T> on StateNotifier<T> {
  StreamSubscription<T> collect(void Function(T) onData) =>
      listen((data) => onData(data));

  Widget collectAsWidget(Widget Function(T) builder, {Widget? emptyData}) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data as T);
        } else {
          return emptyData ?? const SizedBox.shrink();
        }
      },
    );
  }
}
