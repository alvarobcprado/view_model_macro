import 'dart:async';

import 'package:flutter/material.dart';

/// {@template StreamListener}
/// A widget that listens to a [Stream] and calls [onData] when the data changes
/// 
/// Usefull to listen to the stream changes inside the Widget Build method
///  
/// {@endtemplate}

class StreamListener<T> extends StatefulWidget {
  /// {@macro StreamListener}
  const StreamListener({
    required this.stream,
    required this.onData,
    super.key,
    this.child,
  });

  /// The [Stream] to listen to
  final Stream<T> stream;

  /// The callback called when the data changes
  final ValueChanged<T> onData;

  /// The child widget
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
