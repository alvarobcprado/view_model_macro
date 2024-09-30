import 'dart:async';

import 'package:flutter/material.dart';

class StreamListener<T> extends StatefulWidget {
  const StreamListener({
    required this.stream,
    required this.onData,
    super.key,
    this.child,
  });

  final Stream<T> stream;
  final ValueChanged<T> onData;
  final Widget? child;

  @override
  State<StreamListener<T>> createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  late StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(widget.onData);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
