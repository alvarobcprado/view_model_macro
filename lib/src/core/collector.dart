import 'package:flutter/material.dart';

extension StateCollectorX<T> on ValueNotifier<T> {
  Widget collectAsWidget(Widget Function(T, Widget?) builder, {Widget? child}) {
    return ValueListenableBuilder(
      valueListenable: this,
      child: child,
      builder: (context, value, child) => builder(value, child),
    );
  }
}
