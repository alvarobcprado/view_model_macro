import 'package:flutter/material.dart';

extension StateCollectorX<T> on Stream<T> {
  Widget collectAsState(Widget Function(T) builder) {
    return StreamBuilder(
      stream: this,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data as T);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
